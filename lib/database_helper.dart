
import 'package:my_app/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _locationDatabase;
  static Database? _userDatabase;
  static final String locationTableName = 'location_data';
  static final String userTableName = 'users';

  Future<Database> get locationDatabase async {
    if (_locationDatabase != null) return _locationDatabase!;

    _locationDatabase = await _initLocationDatabase();
    return _locationDatabase!;
  }

  Future<Database> get userDatabase async {
    if (_userDatabase != null) return _userDatabase!;

    _userDatabase = await _initUserDatabase();
    return _userDatabase!;
  }

  Future<Database> _initLocationDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'location_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $locationTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL,
            longitude REAL,
            timestamp TEXT
          )
          ''',
        );
      },
    );
  }

  Future<Database> _initUserDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $userTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertLocation(Map<String, dynamic> locationData) async {
    final db = await locationDatabase;
    await db.insert(locationTableName, locationData);
  }

  Future<List<Map<String, dynamic>>> getLocationData() async {
    final db = await locationDatabase;
    return await db.query(locationTableName);
  }

  Future<void> deleteLocation(String timestamp) async {
    final db = await locationDatabase;
    await db.delete(
      locationTableName,
      where: 'timestamp = ?',
      whereArgs: [timestamp],
    );
  }

  Future<int> insertUser(User user) async {
    final db = await userDatabase;
    return await db.insert(userTableName, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await userDatabase;
    final List<Map<String, dynamic>> maps = await db.query(
      userTableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;

    return User(
      id: maps[0]['id'],
      username: maps[0]['username'],
      email: maps[0]['email'],
      password: maps[0]['password'],
    );
  }
}
