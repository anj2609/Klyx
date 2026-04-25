import 'package:dio/dio.dart';

class GitHubService {
  final Dio _dio = Dio();
  
  Future<Map<String, dynamic>> fetchStats(String username, String token) async {
    // Placeholder for actual implementation using GitHub API
    return {};
  }
}

class LeetCodeService {
  Future<Map<String, dynamic>> fetchStats(String username) async {
    // Placeholder
    return {};
  }
}

class CodeforcesService {
  Future<Map<String, dynamic>> fetchStats(String handle) async {
    // Placeholder
    return {};
  }
}
