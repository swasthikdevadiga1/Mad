import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DbService {
  static Database? _database;
  static const String _userTableName = 'users';
  static const String _transactionTableName = 'transactions';
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_userTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $_transactionTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_userTableName (id)
      )
    ''');
  }
  static Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert(_transactionTableName, transaction.toMap());
  }
  static Future<List<TransactionModel>> getAllTransactions(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _transactionTableName,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }
  static Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      _transactionTableName,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
  static Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      _transactionTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  static Future<Map<String, double>> getMonthlyStats(int userId) async {
    final db = await database;
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final incomeResult = await db.rawQuery('''
      SELECT SUM(amount) as total FROM $_transactionTableName
      WHERE type = 'income' AND date >= ? AND date <= ? AND userId = ?
    ''', [
      firstDayOfMonth.toIso8601String(),
      lastDayOfMonth.toIso8601String(),
      userId
    ]);
    final expenseResult = await db.rawQuery('''
      SELECT SUM(amount) as total FROM $_transactionTableName
      WHERE type = 'expense' AND date >= ? AND date <= ? AND userId = ?
    ''', [
      firstDayOfMonth.toIso8601String(),
      lastDayOfMonth.toIso8601String(),
      userId
    ]);
    return {
      'income': incomeResult.first['total'] as double? ?? 0.0,
      'expense': expenseResult.first['total'] as double? ?? 0.0,
    };
  }
}