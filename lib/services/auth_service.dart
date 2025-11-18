import 'package:hive_flutter/hive_flutter.dart';
import '../model/user.dart';

class AuthService {
  static const String _boxName = 'users';

  Future<Box<User>> _getBox() async {
    return await Hive.openBox<User>(_boxName);
  }

  Future<bool> register(String username, String password, {String? name, String? nim}) async {
    final box = await _getBox();
    
    // cek username udah ada apa belom
    final existingUser = box.values.firstWhere(
      (user) => user.username == username,
      orElse: () => User(username: '', password: ''),
    );

    if (existingUser.username.isNotEmpty) {
      return false; // username udah ada
    }

    final user = User(
      username: username,
      password: password,
    );

    await box.add(user);
    return true;
  }

  Future<User?> login(String username, String password) async {
    final box = await _getBox();
    
    try {
      final user = box.values.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    final box = await _getBox();
    
    try {
      final user = box.values.firstWhere(
        (user) => user.username == username,
      );
      return user;
    } catch (e) {
      return null;
    }
  }
}
