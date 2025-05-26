import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/tp_passage.dart';
import '../pages/passages_page.dart';

class PassageDatabase {
  static final PassageDatabase instance = PassageDatabase._init();
  static Database? _database;

  PassageDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');
    _database = await openDatabase(path, version: 1); // Adjust version
    return _database!;
  }

  Future<List<TpPassage>> getAllPassages() async {
    final db = await instance.database;
    final result = await db.query('TP_PASSAGES');
    return result.map((json) => TpPassage.fromMap(json)).toList();
  }

  // Optional: add updatePassageStatus, insert, delete, etc.
}
