import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/models/github_stats.dart';
import 'package:klyx/features/auth/auth_provider.dart';
import 'package:klyx/services/api_providers.dart';

final githubViewModelProvider =
    AsyncNotifierProvider<GitHubViewModel, GitHubStats>(() {
  return GitHubViewModel();
});

class GitHubViewModel extends AsyncNotifier<GitHubStats> {
  @override
  Future<GitHubStats> build() async {
    final authState = ref.watch(authNotifierProvider);
    final profile = authState.value;

    if (profile == null || !profile.hasGithub) {
      return GitHubStats.empty();
    }

    return _fetchStats(profile);
  }

  Future<GitHubStats> _fetchStats(dynamic profile) async {
    final ghService = ref.read(githubServiceProvider);
    final data = await ghService.fetchStats(
      profile.githubId!,
      profile.githubToken ?? '',
    );
    return GitHubStats.fromApiMap(data);
  }

  Future<void> refresh() async {
    final authState = ref.read(authNotifierProvider);
    final profile = authState.value;

    if (profile == null || !profile.hasGithub) {
      state = AsyncValue.data(GitHubStats.empty());
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
