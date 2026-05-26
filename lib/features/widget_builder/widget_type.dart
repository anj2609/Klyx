enum WidgetType {
  githubStreak,
  leetcodeRating,
  codeforcesRating,
  problemsSolved,
  commitCount,
  contributionGrid,
  customStat;

  String get displayName {
    switch (this) {
      case WidgetType.githubStreak:
        return 'GitHub Streak';
      case WidgetType.leetcodeRating:
        return 'LeetCode Solved';
      case WidgetType.codeforcesRating:
        return 'Codeforces Rating';
      case WidgetType.problemsSolved:
        return 'Problems Solved';
      case WidgetType.commitCount:
        return 'Commit Count';
      case WidgetType.contributionGrid:
        return 'Contribution Grid';
      case WidgetType.customStat:
        return 'Custom Stat';
    }
  }

  String get shortLabel {
    switch (this) {
      case WidgetType.githubStreak:
        return 'GH STREAK';
      case WidgetType.leetcodeRating:
        return 'LC SOLVED';
      case WidgetType.codeforcesRating:
        return 'CF RATING';
      case WidgetType.problemsSolved:
        return 'TOTAL SOLVED';
      case WidgetType.commitCount:
        return 'COMMITS';
      case WidgetType.contributionGrid:
        return 'CONTRIBS';
      case WidgetType.customStat:
        return 'CUSTOM';
    }
  }
}
