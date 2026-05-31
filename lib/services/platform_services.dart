import 'dart:convert';
import 'package:dio/dio.dart';

class GitHubService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchStats(String username, String token) async {
    try {
      // 1. Fetch user profile via REST API
      final headers = <String, String>{
        'Accept': 'application/vnd.github.v3+json',
      };
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final profileResponse = await _dio.get(
        'https://api.github.com/users/$username',
        options: Options(headers: headers),
      );
      final profileData = profileResponse.data;

      // 2. Fetch repos to calculate total stars and get top repos
      final reposResponse = await _dio.get(
        'https://api.github.com/users/$username/repos?per_page=100&sort=stars&direction=desc',
        options: Options(headers: headers),
      );
      final reposList = reposResponse.data as List;

      int totalStars = 0;
      final topRepos = <Map<String, dynamic>>[];

      for (final repo in reposList) {
        final repoStars = (repo['stargazers_count'] as int?) ?? 0;
        totalStars += repoStars;
        if (topRepos.length < 5) {
          topRepos.add({
            'name': repo['name'] ?? '',
            'stars': repoStars,
            'language': repo['language'],
          });
        }
      }

      // 3. Fetch contribution data via GraphQL (requires token)
      int totalContribs = 0;
      int currentStreak = 0;
      int longestStreak = 0;
      List<int> heatmap = List.generate(140, (_) => 0);

      if (token.isNotEmpty) {
        try {
          final graphqlResponse = await _dio.post(
            'https://api.github.com/graphql',
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            }),
            data: jsonEncode({
              'query': '''
                query(\$username: String!) {
                  user(login: \$username) {
                    contributionsCollection {
                      contributionCalendar {
                        totalContributions
                        weeks {
                          contributionDays {
                            contributionCount
                            date
                          }
                        }
                      }
                    }
                  }
                }
              ''',
              'variables': {'username': username},
            }),
          );

          final userData = graphqlResponse.data['data']?['user'];
          if (userData != null) {
            final calendar = userData['contributionsCollection']
                ['contributionCalendar'];
            totalContribs = calendar['totalContributions'] ?? 0;

            final weeks = calendar['weeks'] as List;

            // Build flat list of all contribution days
            final allDays = <Map<String, dynamic>>[];
            for (final week in weeks) {
              final days = week['contributionDays'] as List;
              for (final day in days) {
                allDays.add({
                  'count': day['contributionCount'] as int,
                  'date': day['date'] as String,
                });
              }
            }

            // Calculate current streak (from today backwards)
            final today = DateTime.now();
            currentStreak = 0;
            for (int i = allDays.length - 1; i >= 0; i--) {
              final dayDate = DateTime.parse(allDays[i]['date']);
              final count = allDays[i]['count'] as int;

              // Skip future dates
              if (dayDate.isAfter(today)) continue;

              // For today, allow 0 contributions (streak continues)
              if (dayDate.year == today.year &&
                  dayDate.month == today.month &&
                  dayDate.day == today.day) {
                if (count > 0) currentStreak++;
                continue;
              }

              if (count > 0) {
                currentStreak++;
              } else {
                break;
              }
            }

            // Calculate longest streak
            int tempStreak = 0;
            longestStreak = 0;
            for (final day in allDays) {
              if ((day['count'] as int) > 0) {
                tempStreak++;
                if (tempStreak > longestStreak) longestStreak = tempStreak;
              } else {
                tempStreak = 0;
              }
            }

            // Build heatmap from last 20 weeks (140 days)
            final heatmapDays = allDays.length > 140
                ? allDays.sublist(allDays.length - 140)
                : allDays;

            heatmap = List.generate(140, (i) {
              if (i >= heatmapDays.length) return 0;
              final count = heatmapDays[i]['count'] as int;
              if (count == 0) return 0;
              if (count <= 3) return 1;
              if (count <= 6) return 2;
              if (count <= 9) return 3;
              return 4;
            });
          }
        } catch (_) {
          // GraphQL failed, continue with REST data only
        }
      }

      return {
        'username': profileData['login'] ?? username,
        'bio': profileData['bio'] ?? '',
        'followers': profileData['followers'] ?? 0,
        'stars': totalStars,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'totalContribs': totalContribs,
        'heatmap': heatmap,
        'repos': topRepos,
        'avatarUrl': profileData['avatar_url'] ?? '',
      };
    } catch (e) {
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
                profile {
                  realName
                  userAvatar
                  ranking
                }
                submitStats: submitStatsGlobal {
                  acSubmissionNum {
                    difficulty
                    count
                  }
                }
                userCalendar {
                  submissionCalendar
                }
              }
              recentAcSubmissionList(username: \$username, limit: 10) {
                title
                timestamp
                lang
              }
            }
          ''',
          'variables': {'username': username},
        },
      );

      final data = response.data['data']['matchedUser'];
      if (data == null) throw Exception('User not found');
      
      final profile = data['profile'];
      final String realName = profile['realName'] ?? '';
      final String avatar = profile['userAvatar'] ?? '';
      final String rank = profile['ranking']?.toString() ?? 'Unranked';
      
      final recentList = response.data['data']['recentAcSubmissionList'] as List? ?? [];
      final recentSolves = recentList.map((e) => {
        'title': e['title'],
        'timestamp': int.tryParse(e['timestamp']?.toString() ?? '') ?? 0,
        'lang': e['lang'],
      }).toList();

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

      // Parse submission calendar for weekly activity and streak
      List<bool> weekly = List.filled(7, false);
      int leetcodeStreak = 0;
      List<int> heatmap = List.filled(140, 0);
      try {
        final calendarRaw =
            data['userCalendar']?['submissionCalendar'] as String?;
        if (calendarRaw != null && calendarRaw.isNotEmpty) {
          final calendarMap =
              jsonDecode(calendarRaw) as Map<String, dynamic>;

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          
          final weekStart = today.subtract(Duration(days: now.weekday % 7));

          final Set<DateTime> activeDates = {};
          
          for (final entry in calendarMap.entries) {
            final timestamp = int.parse(entry.key);
            final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
            final localDate = DateTime(date.year, date.month, date.day);
            if ((int.tryParse(entry.value.toString()) ?? 0) > 0) {
              activeDates.add(localDate);
            }
          }
          
          for (int i = 0; i < 7; i++) {
             final checkDate = weekStart.add(Duration(days: i));
             if (activeDates.contains(checkDate)) {
               weekly[i] = true;
             }
          }
          
          var streakDate = today;
          if (!activeDates.contains(streakDate)) {
             streakDate = today.subtract(const Duration(days: 1));
          }
          
          while (activeDates.contains(streakDate)) {
             leetcodeStreak++;
             streakDate = streakDate.subtract(const Duration(days: 1));
          }
          
          // Build heatmap (140 days)
          heatmap = List.generate(140, (i) {
            final checkDate = today.subtract(Duration(days: 139 - i));
            // Find timestamp corresponding to this date
            int dayCount = 0;
            for (final entry in calendarMap.entries) {
              final timestamp = int.parse(entry.key);
              final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
              if (date.year == checkDate.year && date.month == checkDate.month && date.day == checkDate.day) {
                dayCount += (int.tryParse(entry.value.toString()) ?? 0);
              }
            }
            if (dayCount == 0) return 0;
            if (dayCount <= 2) return 1;
            if (dayCount <= 4) return 2;
            if (dayCount <= 6) return 3;
            return 4;
          });
          
        }
      } catch (_) {
        // Calendar parsing failed, keep defaults
      }

      return {
        'totalSolved': totalSolved,
        'easy': easySolved,
        'medium': mediumSolved,
        'hard': hardSolved,
        'weekly': weekly,
        'leetcodeStreak': leetcodeStreak,
        'avatar': avatar,
        'realName': realName,
        'rank': rank,
        'heatmap': heatmap,
        'recentSolves': recentSolves,
      };
    } catch (e) {
      throw Exception('Failed to load LeetCode stats');
    }
  }
}

class CodeforcesService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchStats(String handle) async {
    try {
      // Fetch user info
      final infoResponse = await _dio.get(
        'https://codeforces.com/api/user.info?handles=$handle',
      );

      if (infoResponse.data['status'] != 'OK') {
        throw Exception(
            infoResponse.data['comment'] ?? 'Codeforces API error');
      }

      final result = infoResponse.data['result'][0];
      final String avatar = result['titlePhoto'] ?? result['avatar'] ?? '';

      // Fetch rating history for contests played
      int contestsPlayed = 0;
      try {
        final ratingResponse = await _dio.get(
          'https://codeforces.com/api/user.rating?handle=$handle',
        );
        if (ratingResponse.data['status'] == 'OK') {
          contestsPlayed = (ratingResponse.data['result'] as List).length;
        }
      } catch (_) {}

      // Fetch upcoming contests
      List<Map<String, dynamic>> upcomingContests = [];
      try {
        final contestsResponse = await _dio.get(
          'https://codeforces.com/api/contest.list?gym=false',
        );
        if (contestsResponse.data['status'] == 'OK') {
          final contests = (contestsResponse.data['result'] as List)
              .where((c) => c['phase'] == 'BEFORE')
              .take(3)
              .toList();
          for (var c in contests) {
            upcomingContests.add({
              'name': c['name'],
              'startTimeSeconds': c['startTimeSeconds'],
            });
          }
        }
      } catch (_) {}

      // Fetch solved problems count and recent solves
      int solvedCount = 0;
      List<Map<String, dynamic>> recentSolves = [];
      try {
        final statusResponse = await _dio.get(
          'https://codeforces.com/api/user.status?handle=$handle&from=1&count=200',
        );

        if (statusResponse.data['status'] == 'OK') {
          final submissions = statusResponse.data['result'] as List;
          final uniqueProblems = <String>{};

          for (final sub in submissions) {
            if (sub['verdict'] == 'OK') {
              final problem = sub['problem'];
              final problemId =
                  '${problem['contestId']}-${problem['index']}';
              if (!uniqueProblems.contains(problemId)) {
                uniqueProblems.add(problemId);
                if (recentSolves.length < 10) {
                  recentSolves.add({
                    'name': problem['name'],
                    'rating': problem['rating'] ?? 0,
                    'lang': sub['programmingLanguage'],
                    'creationTimeSeconds': sub['creationTimeSeconds'],
                  });
                }
              }
            }
          }
          solvedCount = uniqueProblems.length;
        }
      } catch (_) {
        // Solved count fetch failed, continue with 0
      }

      return {
        'rating': result['rating'] ?? 0,
        'maxRating': result['maxRating'] ?? 0,
        'rank': result['rank'] ?? 'Unrated',
        'solvedCount': solvedCount,
        'avatar': avatar,
        'contestsPlayed': contestsPlayed,
        'upcomingContests': upcomingContests,
        'recentSolves': recentSolves,
      };
    } catch (e) {
      throw Exception('Failed to load Codeforces stats');
    }
  }
}
