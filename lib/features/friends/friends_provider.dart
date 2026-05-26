import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/features/friends/friend_model.dart';
import 'package:klyx/features/friends/friend_stats_model.dart';
import 'package:klyx/features/friends/friends_notifier.dart';
import 'package:klyx/services/platform_services.dart';

final friendsNotifierProvider =
    AsyncNotifierProvider<FriendsNotifier, List<Friend>>(
        () => FriendsNotifier());

final friendStatsProvider =
    FutureProvider.family<FriendStats, Friend>((ref, friend) async {
  Map<String, dynamic>? lcData;
  Map<String, dynamic>? ghData;
  Map<String, dynamic>? cfData;

  Future<void> fetchLc() async {
    try {
      lcData = await LeetCodeService().fetchStats(friend.leetcodeId!);
    } catch (_) {}
  }

  Future<void> fetchGh() async {
    try {
      ghData = await GitHubService().fetchStats(friend.githubId!, '');
    } catch (_) {}
  }

  Future<void> fetchCf() async {
    try {
      cfData = await CodeforcesService().fetchStats(friend.codeforcesId!);
    } catch (_) {}
  }

  await Future.wait([
    if (friend.hasLeetcode) fetchLc(),
    if (friend.hasGithub) fetchGh(),
    if (friend.hasCodeforces) fetchCf(),
  ]);

  return FriendStats(
    friendId: friend.id,
    lcTotalSolved: lcData?['totalSolved'] as int?,
    lcEasy: lcData?['easy'] as int?,
    lcMedium: lcData?['medium'] as int?,
    lcHard: lcData?['hard'] as int?,
    ghContribs: ghData?['totalContribs'] as int?,
    ghFollowers: ghData?['followers'] as int?,
    ghStreak: ghData?['currentStreak'] as int?,
    cfRating: cfData?['rating'] as int?,
    cfMaxRating: cfData?['maxRating'] as int?,
    cfRank: cfData?['rank'] as String?,
  );
});

