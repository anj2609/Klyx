class FriendStats {
  final String friendId;

  // LeetCode
  final int? lcTotalSolved;
  final int? lcEasy;
  final int? lcMedium;
  final int? lcHard;

  // GitHub
  final int? ghContribs;
  final int? ghFollowers;
  final int? ghStreak;

  // Codeforces
  final int? cfRating;
  final int? cfMaxRating;
  final String? cfRank;

  const FriendStats({
    required this.friendId,
    this.lcTotalSolved,
    this.lcEasy,
    this.lcMedium,
    this.lcHard,
    this.ghContribs,
    this.ghFollowers,
    this.ghStreak,
    this.cfRating,
    this.cfMaxRating,
    this.cfRank,
  });

  int get totalScore => (lcTotalSolved ?? 0) + (ghContribs ?? 0) + (cfRating ?? 0);

  factory FriendStats.empty(String friendId) => FriendStats(friendId: friendId);
}
