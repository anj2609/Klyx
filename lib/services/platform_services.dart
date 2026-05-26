import 'package:dio/dio.dart';

class GitHubService {
  final Dio _dio = Dio();
  
  Future<Map<String, dynamic>> fetchStats(String username, String token) async {
    try {
      final response = await _dio.get(
        'https://api.github.com/users/$username',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.github.v3+json',
        }),
      );
      
      final data = response.data;
      
      // To get real contribution data, we'd typically need the GraphQL API.
      // For the scope of this implementation, we will use the user data and 
      // mock the heatmap and total contribs to keep it functional.
      return {
        'username': data['login'] ?? username,
        'bio': data['bio'] ?? '',
        'followers': data['followers'] ?? 0,
        'stars': 0, // Requires fetching repos
        'currentStreak': 0, // Requires calculating from events
        'longestStreak': 0,
        'totalContribs': 0, // Requires GraphQL
        'heatmap': List.generate(140, (index) => 0), // Mocked for now
      };
    } catch (e) {
      print('Error fetching GitHub stats: $e');
      throw Exception('Failed to load GitHub stats');
    }
  }
}

class LeetCodeService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchStats(String username) async {
    try {
      final response = await _dio.post(
        'https://leetcode.com/graphql',
        data: {
          'query': '''
            query getUserProfile(\$username: String!) {
              matchedUser(username: \$username) {
                username
                submitStats: submitStatsGlobal {
                  acSubmissionNum {
                    difficulty
                    count
                    submissions
                  }
                }
              }
            }
          ''',
          'variables': {'username': username},
        },
      );
      
      final data = response.data['data']['matchedUser'];
      if (data == null) throw Exception('User not found');
      
      final stats = data['submitStats']['acSubmissionNum'] as List;
      int totalSolved = 0;
      int easySolved = 0;
      int mediumSolved = 0;
      int hardSolved = 0;
      
      for (var stat in stats) {
        if (stat['difficulty'] == 'All') totalSolved = stat['count'];
        if (stat['difficulty'] == 'Easy') easySolved = stat['count'];
        if (stat['difficulty'] == 'Medium') mediumSolved = stat['count'];
        if (stat['difficulty'] == 'Hard') hardSolved = stat['count'];
      }
      
      return {
        'totalSolved': totalSolved,
        'easy': easySolved,
        'medium': mediumSolved,
        'hard': hardSolved,
        'weekly': [true, true, true, true, true, false, false], // Mocked weekly
      };
    } catch (e) {
      print('Error fetching LeetCode stats: $e');
      throw Exception('Failed to load LeetCode stats');
    }
  }
}

class CodeforcesService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchStats(String handle) async {
    try {
      final response = await _dio.get(
        'https://codeforces.com/api/user.info?handles=$handle',
      );
      
      if (response.data['status'] == 'OK') {
        final result = response.data['result'][0];
        return {
          'rating': result['rating'] ?? 0,
          'maxRating': result['maxRating'] ?? 0,
          'rank': result['rank'] ?? 'Unrated',
        };
      } else {
        throw Exception(response.data['comment'] ?? 'Codeforces API error');
      }
    } catch (e) {
      print('Error fetching Codeforces stats: $e');
      throw Exception('Failed to load Codeforces stats');
    }
  }
}
