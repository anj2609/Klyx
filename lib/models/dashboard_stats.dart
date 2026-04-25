class DashboardStats {
  final int totalCompetitiveSolved;
  final int githubContribs;
  final int leetcodeSolved;
  final int codeforcesRating;
  final int githubStreak;
  final List<bool> leetcodeWeekly;

  DashboardStats({
    required this.totalCompetitiveSolved,
    required this.githubContribs,
    required this.leetcodeSolved,
    required this.codeforcesRating,
    required this.githubStreak,
    required this.leetcodeWeekly,
  });

  factory DashboardStats.mock() {
    return DashboardStats(
      totalCompetitiveSolved: 154,
      githubContribs: 379,
      leetcodeSolved: 117,
      codeforcesRating: 1619,
      githubStreak: 1,
      leetcodeWeekly: [true, true, true, true, true, true, false],
    );
  }
}
