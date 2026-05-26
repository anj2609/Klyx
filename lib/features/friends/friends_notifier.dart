import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/features/friends/friend_model.dart';
import 'package:klyx/features/friends/friends_repository.dart';

class FriendsNotifier extends AsyncNotifier<List<Friend>> {
  final _repo = FriendsRepository();

  @override
  FutureOr<List<Friend>> build() async {
    return _repo.getAll();
  }

  Future<void> addFriend(Friend friend) async {
    state = const AsyncValue.loading();
    try {
      await _repo.add(friend);
      state = AsyncValue.data(await _repo.getAll());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeFriend(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.remove(id);
      state = AsyncValue.data(await _repo.getAll());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _repo.getAll());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
