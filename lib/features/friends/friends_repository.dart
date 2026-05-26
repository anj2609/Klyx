import 'package:shared_preferences/shared_preferences.dart';
import 'package:klyx/features/friends/friend_model.dart';

const _kFriendsKey = 'klyx_friends_list';

class FriendsRepository {
  Future<List<Friend>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kFriendsKey);
    return Friend.decodeList(raw);
  }

  Future<void> saveAll(List<Friend> friends) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFriendsKey, Friend.encodeList(friends));
  }

  Future<void> add(Friend friend) async {
    final friends = await getAll();
    friends.add(friend);
    await saveAll(friends);
  }

  Future<void> remove(String id) async {
    final friends = await getAll();
    friends.removeWhere((f) => f.id == id);
    await saveAll(friends);
  }

  Future<void> update(Friend updated) async {
    final friends = await getAll();
    final idx = friends.indexWhere((f) => f.id == updated.id);
    if (idx != -1) {
      friends[idx] = updated;
      await saveAll(friends);
    }
  }
}
