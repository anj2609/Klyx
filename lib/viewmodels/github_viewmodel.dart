import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/models/github_stats.dart';

final githubViewModelProvider = NotifierProvider<GitHubViewModel, GitHubStats>(() {
  return GitHubViewModel();
});

class GitHubViewModel extends Notifier<GitHubStats> {
  @override
  GitHubStats build() {
    return GitHubStats.mock();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    state = GitHubStats.mock();
  }
}
