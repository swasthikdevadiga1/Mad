import '../models/user_model.dart';
import 'db_service.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    final db = await DbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password'],
      );
    }
    return null;
  }

  Future<void> register(UserModel user) async {
    final db = await DbService.database;
    await db.insert('users', user.toMap());
  }
}