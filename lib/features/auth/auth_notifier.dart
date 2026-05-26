import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:klyx/features/auth/auth_model.dart';

const _kProfileKey = 'klyx_user_profile';

class AuthNotifier extends AsyncNotifier<UserProfile?> {
  final _storage = const FlutterSecureStorage();

  @override
  FutureOr<UserProfile?> build() async {
    return _loadProfile();
  }

  Future<UserProfile?> _loadProfile() async {
    final raw = await _storage.read(key: _kProfileKey);
    return UserProfile.decode(raw);
  }

  Future<void> login(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      await _storage.write(key: _kProfileKey, value: profile.encode());
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _storage.delete(key: _kProfileKey);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> skipLogin() async {
    // Save an empty profile to signal user has seen onboarding
    final emptyProfile = const UserProfile();
    await _storage.write(key: _kProfileKey, value: emptyProfile.encode());
    state = AsyncValue.data(emptyProfile);
  }
}
