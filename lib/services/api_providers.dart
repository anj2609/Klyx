import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/services/platform_services.dart';

final githubServiceProvider = Provider<GitHubService>((ref) => GitHubService());
final leetcodeServiceProvider = Provider<LeetCodeService>((ref) => LeetCodeService());
final codeforcesServiceProvider = Provider<CodeforcesService>((ref) => CodeforcesService());
