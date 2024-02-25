import 'package:enavit/models/notify.dart';
import 'package:sqflite/sqflite.dart';

class DBSql {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'notify';

  static Future<void> initDb() async {
    if (_database != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath();
      _database = await openDatabase(
        '${_path}notify.db',
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE notify(id INTEGER PRIMARY KEY, title TEXT, body TEXT, image TEXT, time TEXT, date TEXT)',
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> insertNotify(Notify? notify) async {
    await _database?.insert('notify', notify!.toJson()  ,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Future<List<Map<String, Object?>>>?> notifyList() async {
    return _database?.query('notify');
  }

  static Future<void> updateNotify(Map<String, dynamic> notify) async {
    final Database db = await database();
    await db.update(
      'notify',
      notify,
      where: 'id = ?',
      whereArgs: [notify['id']],
    );
  }

  static Future<void> deleteNotify(int id) async {
    final Database db = await database();
    await db.delete(
      'notify',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
