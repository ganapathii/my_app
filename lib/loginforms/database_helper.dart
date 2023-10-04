// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class User {
//   final int? id;
//   final String username;
//   final String email;
//   final String password;

//   User({
//     this.id,
//     required this.username,
//     required this.email,
//     required this.password,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'username': username,
//       'email': email,
//       'password': password,
//     };
//   }
// }

// class DatabaseHelper {
//   Database? _database;

//   Future<Database?> get database async {
//     if (_database != null) return _database;

//     _database = await initDatabase();
//     return _database;
//   }

//   Future<Database> initDatabase() async {
//     String path = join(await getDatabasesPath(), 'user_database.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE users(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             username TEXT,
//             email TEXT UNIQUE,
//             password TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> insertUser(User user) async {
//     final db = await database;
//     return await db!.insert('users', user.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<User?> getUserByEmail(String email) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db!.query(
//       'users',
//       where: 'email = ?',
//       whereArgs: [email],
//     );

//     if (maps.isEmpty) return null;

//     return User(
//       id: maps[0]['id'],
//       username: maps[0]['username'],
//       email: maps[0]['email'],
//       password: maps[0]['password'],
//     );
//   }
// }
