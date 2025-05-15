import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RpRepriseObjectsMigration extends Migration {
  RpRepriseObjectsMigration()
      : super(version: 15, description: 'Create RP_REPRISE_OBJECTS table');
  @override
  int get version =>
      15; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');

    // Create the table
    await db.execute('''
      CREATE TABLE RP_REPRISE_OBJECTS (
        RP_REFERENCE_ID TEXT NOT NULL,
        TP_PASSAGE_ID TEXT NOT NULL,
        TP_TOURNE_ID TEXT NOT NULL,
        TR_POINT_STOP_ID TEXT NOT NULL,
        RF_OBJECT_ID TEXT,
        MONTANT REAL,
        QUANTITE INTEGER,
        PRIMARY KEY (RP_REFERENCE_ID, TP_PASSAGE_ID, TP_TOURNE_ID, TR_POINT_STOP_ID),
        FOREIGN KEY (RF_OBJECT_ID) 
          REFERENCES RF_OBJECTS (RF_OBJECT_ID) 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        FOREIGN KEY (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          REFERENCES TP_PASSAGES (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          ON DELETE RESTRICT ON UPDATE RESTRICT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RP_REPRISE_OBJECTS');
  }
}
