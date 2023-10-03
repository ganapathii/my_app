import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'location_data';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'location_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName(
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

  Future<void> insertLocation(Map<String, dynamic> locationData) async {
    final db = await database;
    await db.insert(_tableName, locationData);
  }

  Future<List<Map<String, dynamic>>> getLocationData() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<void> deleteLocation(String timestamp) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'timestamp = ?',
      whereArgs: [timestamp],
    );
  }

  getUserByEmail(String email) {}
}