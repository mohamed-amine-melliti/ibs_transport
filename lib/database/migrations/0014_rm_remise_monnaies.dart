import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RmRemiseMonnaiesMigration extends Migration {
  RmRemiseMonnaiesMigration() : super(version: 14, description: 'Create RM_REMISE_MONNAIES table');
  @override
  int get version => 14; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
    
    // Create the table
    await db.execute('''
      CREATE TABLE RM_REMISE_MONNAIES (
        RM_REFERENCE_ID TEXT NOT NULL,
        TP_PASSAGE_ID TEXT NOT NULL,
        TR_POINT_STOP_ID TEXT NOT NULL,
        TYPE TEXT,
        MONTAN REAL,
        PRIMARY KEY (RM_REFERENCE_ID, TP_PASSAGE_ID, TR_POINT_STOP_ID),
        FOREIGN KEY (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          REFERENCES TP_PASSAGES (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          ON DELETE RESTRICT ON UPDATE RESTRICT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RM_REMISE_MONNAIES');
  }
}