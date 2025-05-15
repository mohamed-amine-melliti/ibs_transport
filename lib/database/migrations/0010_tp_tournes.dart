import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class TpTournesMigration extends Migration {
  TpTournesMigration() : super(version: 10, description: 'Create TP_TOURNES table');
  @override
  int get version => 10; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
    
    // Create the table
    await db.execute('''
      CREATE TABLE TP_TOURNES (
        TP_TOURNE_ID TEXT NOT NULL,
        RF_STATUS_ID INTEGER,
        MT_DATE_JOURNE TEXT NOT NULL,
        LIBELLE TEXT,
        CHAUFFEUR TEXT,
        CONVOYEUR TEXT,
        CONVOYEUR_MATRECULE TEXT,
        CONVOYEUR_CIN TEXT,
        FOURGON TEXT,
        HEURE_DEPART TEXT,
        KILOMETRAGE_DEPART INTEGER,
        HEURE_RETOUR TEXT,
        KILOMETRAGE_RETOUR INTEGER,
        NBR_PASSAGES INTEGER NOT NULL,
        PRIMARY KEY (TP_TOURNE_ID),
        FOREIGN KEY (RF_STATUS_ID) REFERENCES RF_TOURNE_STATUS (RF_STATUS_ID) ON DELETE RESTRICT ON UPDATE RESTRICT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS TP_TOURNES');
  }
}