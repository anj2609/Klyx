class GitHubRepo {
  final String name;
  final int stars;
  final String? language;

  const GitHubRepo({
    required this.name,
    required this.stars,
    this.language,
  });
}

class GitHubStats {
  final String username;
  final String bio;
  final int followers;
  final int stars;
  final int currentStreak;
  final int longestStreak;
  final int totalContribs;
  final List<int> heatmap; // 0-4 intensity
  final List<GitHubRepo> repos;
  final String avatarUrl;

  GitHubStats({
    required this.username,
    required this.bio,
    required this.followers,
    required this.stars,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalContribs,
    required this.heatmap,
    required this.repos,
    required this.avatarUrl,
  });

  factory GitHubStats.fromApiMap(Map<String, dynamic> data) {
    final reposList = (data['repos'] as List<dynamic>?) ?? [];
    return GitHubStats(
      username: (data['username'] as String?) ?? '',
      bio: (data['bio'] as String?) ?? '',
      followers: (data['followers'] as int?) ?? 0,
      stars: (data['stars'] as int?) ?? 0,
      currentStreak: (data['currentStreak'] as int?) ?? 0,
      longestStreak: (data['longestStreak'] as int?) ?? 0,
      totalContribs: (data['totalContribs'] as int?) ?? 0,
      heatmap: ((data['heatmap'] as List<dynamic>?) ?? List.generate(140, (_) => 0))
          .cast<int>(),
      avatarUrl: (data['avatarUrl'] as String?) ?? '',
      repos: reposList
          .map((r) => GitHubRepo(
                name: (r['name'] as String?) ?? '',
                stars: (r['stars'] as int?) ?? 0,
                language: r['language'] as String?,
              ))
          .toList(),
    );
  }

  factory GitHubStats.empty() {
    return GitHubStats(
      username: '',
      bio: '',
      followers: 0,
      stars: 0,
      currentStreak: 0,
      longestStreak: 0,
      totalContribs: 0,
      heatmap: List.generate(140, (_) => 0),
      repos: [],
      avatarUrl: '',
    );
  }
}
