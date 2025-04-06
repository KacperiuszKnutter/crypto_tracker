import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'crypto_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT UNIQUE,
            password TEXT
          );
        ''');
      },
    );
  }

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<UserModel?> findUserbyEmail(String? uid) async{
    if (uid == null) return null; // jeśli nie ma zalogowanego użytkownika

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'crypto_tracker.db');
    final db = await openDatabase(path);

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [uid],
    );
    //jeśli znaleziono użytkownika o takim mailu to zwróć wszystkie dane o nim
    if(result.isNotEmpty){
      return UserModel.fromMap(result.first);
    }

    return null;
  }

  Future<bool> registerUser(String username, String email, String password) async {
    final dbClient = await db;

    final hashed = hashPassword(password);
    final check = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (check.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Konto już istnieje');
      return false;
    }

    await dbClient.insert('users', {
      'username': username,
      'email': email,
      'password': hashed,
    });

    Fluttertoast.showToast(msg: 'Zarejestrowano pomyślnie!');
    return true;
  }

  Future<bool> loginUser(String email, String password) async {
    final dbClient = await db;

    final hashed = hashPassword(password);
    final result = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashed],
    );

    if (result.isEmpty) {
      Fluttertoast.showToast(msg: 'Nieprawidłowe dane logowania');
      return false;
    }

    Fluttertoast.showToast(msg: 'Zalogowano!');
    return true;
  }
}
