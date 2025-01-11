import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'attendance.db');
    return await openDatabase(path, version: 1);
  }

  Future<void> createEventTable(String eventId) async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $eventId(
        userId TEXT PRIMARY KEY,
        regNo TEXT,
        name TEXT,
        attended INTEGER
      )
    ''');
  }

  Future<void> insertAttendee(String eventId, String userId, String regNo, String name) async {
    eventId = eventId.replaceAll(" ", '');
    final db = await database;
    await createEventTable(eventId);
    await db.insert(
      eventId,
      {'userId': userId, 'regNo': regNo, 'name': name, 'attended': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<Map<String, dynamic>?> getAttendee(String eventId, String userId) async {
    eventId = eventId.replaceAll(" ", '');
    final db = await database;
    await createEventTable(eventId);
    final result = await db.query(
      eventId,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    final all = await db.query(
      eventId,
    );
    print(all);
    print(result);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> markAttendance(String eventId, String userId) async {
    eventId = eventId.replaceAll(" ", '');
    final db = await database;
    await createEventTable(eventId);
    await db.update(
      eventId,
      {'attended': 1},
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
