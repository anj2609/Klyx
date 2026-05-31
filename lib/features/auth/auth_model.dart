import 'dart:convert';

class UserProfile {
  final String? leetcodeId;
  final String? githubId;
  final String? githubToken;
  final String? codeforcesId;

  const UserProfile({
    this.leetcodeId,
    this.githubId,
    this.githubToken,
    this.codeforcesId,
  });

  bool get isEmpty =>
      (leetcodeId == null || leetcodeId!.isEmpty) &&
      (githubId == null || githubId!.isEmpty) &&
      (codeforcesId == null || codeforcesId!.isEmpty);

  bool get hasLeetcode => leetcodeId != null && leetcodeId!.isNotEmpty;
  bool get hasGithub => githubId != null && githubId!.isNotEmpty;
  bool get hasCodeforces => codeforcesId != null && codeforcesId!.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'leetcodeId': leetcodeId,
        'githubId': githubId,
        'githubToken': githubToken,
        'codeforcesId': codeforcesId,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        leetcodeId: json['leetcodeId'] as String?,
        githubId: json['githubId'] as String?,
        githubToken: json['githubToken'] as String?,
        codeforcesId: json['codeforcesId'] as String?,
      );

  String encode() => jsonEncode(toJson());

  static UserProfile? decode(String? source) {
    if (source == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(source) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  UserProfile copyWith({
    String? leetcodeId,
    String? githubId,
    String? githubToken,
    String? codeforcesId,
  }) =>
      UserProfile(
        leetcodeId: leetcodeId ?? this.leetcodeId,
        githubId: githubId ?? this.githubId,
        githubToken: githubToken ?? this.githubToken,
        codeforcesId: codeforcesId ?? this.codeforcesId,
      );
}
