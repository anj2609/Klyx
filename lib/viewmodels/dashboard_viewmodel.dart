import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/models/dashboard_stats.dart';
import 'package:klyx/features/auth/auth_provider.dart';
import 'package:klyx/services/api_providers.dart';
import 'package:klyx/services/notification_service.dart';

final dashboardViewModelProvider =
    AsyncNotifierProvider<DashboardViewModel, DashboardStats>(() {
  return DashboardViewModel();
});

class DashboardViewModel extends AsyncNotifier<DashboardStats> {
  @override
  Future<DashboardStats> build() async {
    final authState = ref.watch(authNotifierProvider);
    final profile = authState.value;

    // If user skipped login (empty profile) or no profile, show empty stats
    if (profile == null || profile.isEmpty) {
      return DashboardStats.empty();
    }

    return _fetchStats(profile);
  }

  Future<DashboardStats> _fetchStats(dynamic profile) async {
    Map<String, dynamic>? lcData;
    Map<String, dynamic>? cfData;
    Map<String, dynamic>? ghData;

    final lcService = ref.read(leetcodeServiceProvider);
    final cfService = ref.read(codeforcesServiceProvider);
    final ghService = ref.read(githubServiceProvider);

    // Fetch all platform data in parallel
    await Future.wait([
      if (profile.hasLeetcode)
        lcService.fetchStats(profile.leetcodeId!).then((data) => lcData = data).catchError((_) => <String, dynamic>{}),
      if (profile.hasCodeforces)
        cfService.fetchStats(profile.codeforcesId!).then((data) => cfData = data).catchError((_) => <String, dynamic>{}),
      if (profile.hasGithub)
        ghService
            .fetchStats(profile.githubId!, profile.githubToken ?? '')
            .then((data) => ghData = data)
            .catchError((_) => <String, dynamic>{}),
    ]);

    final stats = DashboardStats.fromApi(
      leetcodeData: lcData,
      codeforcesData: cfData,
      githubData: ghData,
    );

    _scheduleCFNotifications(stats.codeforcesUpcomingContests);

    return stats;
  }

  void _scheduleCFNotifications(List<Map<String, dynamic>> upcoming) {
    for (int i = 0; i < upcoming.length; i++) {
      final contest = upcoming[i];
      final name = contest['name'] as String? ?? 'Codeforces Contest';
      final startTimeSeconds = contest['startTimeSeconds'] as int?;
      if (startTimeSeconds != null) {
        final startTime = DateTime.fromMillisecondsSinceEpoch(startTimeSeconds * 1000);
        
        // 0. Notification 8 hours before
        NotificationService().scheduleContestNotification(
          id: (name.hashCode + i + 4000).abs(),
          title: 'Codeforces Contest Today!',
          body: '$name starts in 8 hours!',
          scheduledDate: startTime.subtract(const Duration(hours: 8)),
        );

        // 1. Notification 1 hour before
        NotificationService().scheduleContestNotification(
          id: (name.hashCode + i + 1000).abs(),
          title: 'Upcoming Codeforces Contest!',
          body: '$name starts in 1 hour!',
          scheduledDate: startTime.subtract(const Duration(hours: 1)),
        );

        // 2. Notification 15 minutes before
        NotificationService().scheduleContestNotification(
          id: (name.hashCode + i + 2000).abs(),
          title: 'Codeforces Contest Alert!',
          body: '$name starts in 15 minutes!',
          scheduledDate: startTime.subtract(const Duration(minutes: 15)),
        );

        // 3. Notification at start time
        NotificationService().scheduleContestNotification(
          id: (name.hashCode + i + 3000).abs(),
          title: 'Codeforces Contest Live!',
          body: '$name has started now!',
          scheduledDate: startTime,
        );
      }
    }
  }

  Future<void> refresh() async {
    final authState = ref.read(authNotifierProvider);
    final profile = authState.value;
    if (profile == null || profile.isEmpty) {
      state = AsyncValue.data(DashboardStats.empty());
      return;
    }

    state = const AsyncValue.loading();
    try {
      final stats = await _fetchStats(profile);
      state = AsyncValue.data(stats);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
