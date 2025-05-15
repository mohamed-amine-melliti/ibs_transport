import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class TpPassagesMigration extends Migration {
  TpPassagesMigration() : super(version: 11, description: 'Create TP_PASSAGES table');
  @override
  int get version => 11; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
    
    // Create the table
    await db.execute('''
      CREATE TABLE TP_PASSAGES (
        TP_PASSAGE_ID TEXT NOT NULL,
        TR_POINT_STOP_ID TEXT NOT NULL,
        TP_TOURNE_ID TEXT NOT NULL,
        RF_STATUS_ID INTEGER,
        RF_RESULTAT_ID INTEGER,
        TR_CLIENT_ID TEXT,
        MT_DATE_JOURNE TEXT NOT NULL,
        POINT_STOP_CODE TEXT NOT NULL,
        POINT_STOP_LIBELLE TEXT NOT NULL,
        CLIENT_LIBELLE TEXT NOT NULL,
        ORDRE INTEGER,
        BENEFICIER_NATURE TEXT NOT NULL,
        POINT_STOP_DEST_LIBELLE TEXT,
        ORDRE_PASSAGE TEXT NOT NULL,
        CONVENTION_NATURE TEXT NOT NULL,
        INTERVENTION_NATURE TEXT NOT NULL,
        HEURE_INTERVENTION TEXT,
        INTERVENTION_LIBELLE TEXT,
        NBR_ALIM_BILLET INTEGER NOT NULL,
        NBR_ALIM_MONNAIE INTEGER NOT NULL,
        NBR_REMISE_OBJET INTEGER NOT NULL,
        NBR_RETOUR_OBJET INTEGER NOT NULL,
        PRIMARY KEY (TP_PASSAGE_ID, TR_POINT_STOP_ID),
        FOREIGN KEY (TP_TOURNE_ID) REFERENCES TP_TOURNES (TP_TOURNE_ID) ON DELETE RESTRICT ON UPDATE RESTRICT,
        FOREIGN KEY (RF_STATUS_ID) REFERENCES RF_PASSAGE_STATUS (RF_STATUS_ID) ON DELETE RESTRICT ON UPDATE RESTRICT,
        FOREIGN KEY (RF_RESULTAT_ID) REFERENCES RF_PASSAGE_RESULTATS (RF_RESULTAT_ID) ON DELETE RESTRICT ON UPDATE RESTRICT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS TP_PASSAGES');
  }
}