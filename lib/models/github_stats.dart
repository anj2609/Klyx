class GitHubStats {
  final String username;
  final String bio;
  final int followers;
  final int stars;
  final int currentStreak;
  final int longestStreak;
  final int totalContribs;
  final List<int> heatmap; // 0-4 intensity

  GitHubStats({
    required this.username,
    required this.bio,
    required this.followers,
    required this.stars,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalContribs,
    required this.heatmap,
  });

  factory GitHubStats.mock() {
    return GitHubStats(
      username: 'SHREYANSHU',
      bio: 'IOS AND MERN DEVELOPER',
      followers: 45,
      stars: 0,
      currentStreak: 1,
      longestStreak: 5,
      totalContribs: 379,
      heatmap: List.generate(140, (index) => (index % 7 == 0 || index % 13 == 0) ? (index % 5) : 0),
    );
  }
}
