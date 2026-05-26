import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/features/auth/auth_model.dart';
import 'package:klyx/features/auth/auth_notifier.dart';

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserProfile?>(() => AuthNotifier());

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(data: (profile) => profile != null) ?? false;
});
