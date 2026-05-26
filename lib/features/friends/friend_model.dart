import 'dart:convert';

class Friend {
  final String id;
  final String displayName;
  final String? leetcodeId;
  final String? githubId;
  final String? codeforcesId;
  final DateTime addedAt;

  Friend({
    required this.id,
    required this.displayName,
    this.leetcodeId,
    this.githubId,
    this.codeforcesId,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  bool get hasLeetcode => leetcodeId != null && leetcodeId!.isNotEmpty;
  bool get hasGithub => githubId != null && githubId!.isNotEmpty;
  bool get hasCodeforces => codeforcesId != null && codeforcesId!.isNotEmpty;

  int get platformCount =>
      (hasLeetcode ? 1 : 0) + (hasGithub ? 1 : 0) + (hasCodeforces ? 1 : 0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'leetcodeId': leetcodeId,
        'githubId': githubId,
        'codeforcesId': codeforcesId,
        'addedAt': addedAt.toIso8601String(),
      };

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        leetcodeId: json['leetcodeId'] as String?,
        githubId: json['githubId'] as String?,
        codeforcesId: json['codeforcesId'] as String?,
        addedAt: DateTime.parse(json['addedAt'] as String),
      );

  static List<Friend> decodeList(String? source) {
    if (source == null || source.isEmpty) return [];
    try {
      final list = jsonDecode(source) as List;
      return list
          .map((e) => Friend.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static String encodeList(List<Friend> friends) =>
      jsonEncode(friends.map((f) => f.toJson()).toList());
}
