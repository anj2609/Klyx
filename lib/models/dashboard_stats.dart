class DashboardStats {
  final int totalCompetitiveSolved;
  final int githubContribs;
  final int leetcodeSolved;
  final int codeforcesRating;
  final int codeforcesSolved;
  final int githubStreak;
  final int leetcodeStreak;
  final int leetcodeEasy;
  final int leetcodeMedium;
  final int leetcodeHard;
  final String leetcodeAvatar;
  final String leetcodeRealName;
  final String leetcodeRank;
  final List<int> leetcodeSubmissionsHeatmap;
  final List<Map<String, dynamic>> leetcodeRecentSolves;

  final int codeforcesMaxRating;
  final String codeforcesRank;
  final String codeforcesAvatar;
  final int codeforcesContestsPlayed;
  final List<Map<String, dynamic>> codeforcesUpcomingContests;
  final List<Map<String, dynamic>> codeforcesRecentSolves;
  final List<bool> leetcodeWeekly;

  DashboardStats({
    required this.totalCompetitiveSolved,
    required this.githubContribs,
    required this.leetcodeSolved,
    required this.codeforcesRating,
    required this.codeforcesSolved,
    required this.githubStreak,
    required this.leetcodeStreak,
    required this.leetcodeEasy,
    required this.leetcodeMedium,
    required this.leetcodeHard,
    required this.leetcodeAvatar,
    required this.leetcodeRealName,
    required this.leetcodeRank,
    required this.leetcodeSubmissionsHeatmap,
    required this.leetcodeRecentSolves,
    required this.codeforcesMaxRating,
    required this.codeforcesRank,
    required this.codeforcesAvatar,
    required this.codeforcesContestsPlayed,
    required this.codeforcesUpcomingContests,
    required this.codeforcesRecentSolves,
    required this.leetcodeWeekly,
  });

  factory DashboardStats.fromApi({
    Map<String, dynamic>? leetcodeData,
    Map<String, dynamic>? codeforcesData,
    Map<String, dynamic>? githubData,
  }) {
    final lcSolved = (leetcodeData?['totalSolved'] as int?) ?? 0;
    final cfSolved = (codeforcesData?['solvedCount'] as int?) ?? 0;

    return DashboardStats(
      totalCompetitiveSolved: lcSolved + cfSolved,
      githubContribs: (githubData?['totalContribs'] as int?) ?? 0,
      leetcodeSolved: lcSolved,
      codeforcesRating: (codeforcesData?['rating'] as int?) ?? 0,
      codeforcesSolved: cfSolved,
      githubStreak: (githubData?['currentStreak'] as int?) ?? 0,
      leetcodeStreak: (leetcodeData?['leetcodeStreak'] as int?) ?? 0,
      leetcodeEasy: (leetcodeData?['easy'] as int?) ?? 0,
      leetcodeMedium: (leetcodeData?['medium'] as int?) ?? 0,
      leetcodeHard: (leetcodeData?['hard'] as int?) ?? 0,
      leetcodeAvatar: (leetcodeData?['avatar'] as String?) ?? '',
      leetcodeRealName: (leetcodeData?['realName'] as String?) ?? '',
      leetcodeRank: (leetcodeData?['rank'] as String?) ?? '',
      leetcodeSubmissionsHeatmap: (leetcodeData?['heatmap'] as List<int>?) ?? List.filled(140, 0),
      leetcodeRecentSolves: (leetcodeData?['recentSolves'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      codeforcesMaxRating: (codeforcesData?['maxRating'] as int?) ?? 0,
      codeforcesRank: (codeforcesData?['rank'] as String?) ?? 'Unrated',
      codeforcesAvatar: (codeforcesData?['avatar'] as String?) ?? '',
      codeforcesContestsPlayed: (codeforcesData?['contestsPlayed'] as int?) ?? 0,
      codeforcesUpcomingContests: (codeforcesData?['upcomingContests'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      codeforcesRecentSolves: (codeforcesData?['recentSolves'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      leetcodeWeekly: (leetcodeData?['weekly'] as List<bool>?) ??
          List.filled(7, false),
    );
  }

  factory DashboardStats.empty() {
    return DashboardStats(
      totalCompetitiveSolved: 0,
      githubContribs: 0,
      leetcodeSolved: 0,
      codeforcesRating: 0,
      codeforcesSolved: 0,
      githubStreak: 0,
      leetcodeStreak: 0,
      leetcodeEasy: 0,
      leetcodeMedium: 0,
      leetcodeHard: 0,
      leetcodeAvatar: '',
      leetcodeRealName: '',
      leetcodeRank: '',
      leetcodeSubmissionsHeatmap: List.filled(140, 0),
      leetcodeRecentSolves: [],
      codeforcesMaxRating: 0,
      codeforcesRank: 'Unrated',
      codeforcesAvatar: '',
      codeforcesContestsPlayed: 0,
      codeforcesUpcomingContests: [],
      codeforcesRecentSolves: [],
      leetcodeWeekly: [false, false, false, false, false, false, false],
    );
  }
}
