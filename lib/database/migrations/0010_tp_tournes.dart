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

    // Insert hardcoded data
    await db.insert('TP_TOURNES', {
      'TP_TOURNE_ID': '1',
      'RF_STATUS_ID': 0,
      'MT_DATE_JOURNE': '2024-05-01',
      'LIBELLE': 'Client A',
      'CHAUFFEUR': 'Chauffeur A',
      'CONVOYEUR': 'Convoyeur A',
      'CONVOYEUR_MATRECULE': 'C123',
      'CONVOYEUR_CIN': 'CIN123',
      'FOURGON': 'Fourgon A',
      'HEURE_DEPART': '08:00',
      'KILOMETRAGE_DEPART': 12000,
      'HEURE_RETOUR': '16:00',
      'KILOMETRAGE_RETOUR': 12500,
      'NBR_PASSAGES': 10,
    });

    await db.insert('TP_TOURNES', {
      'TP_TOURNE_ID': '2',
      'RF_STATUS_ID': 1,
      'MT_DATE_JOURNE': '2024-05-02',
      'LIBELLE': 'Client B',
      'CHAUFFEUR': 'Chauffeur B',
      'CONVOYEUR': 'Convoyeur B',
      'CONVOYEUR_MATRECULE': 'C124',
      'CONVOYEUR_CIN': 'CIN124',
      'FOURGON': 'Fourgon B',
      'HEURE_DEPART': '09:00',
      'KILOMETRAGE_DEPART': 15000,
      'HEURE_RETOUR': '17:00',
      'KILOMETRAGE_RETOUR': 15600,
      'NBR_PASSAGES': 8,
    });

    await db.insert('TP_TOURNES', {
      'TP_TOURNE_ID': '3',
      'RF_STATUS_ID': 2,
      'MT_DATE_JOURNE': '2024-05-03',
      'LIBELLE': 'Client C',
      'CHAUFFEUR': 'Chauffeur C',
      'CONVOYEUR': 'Convoyeur C',
      'CONVOYEUR_MATRECULE': 'C125',
      'CONVOYEUR_CIN': 'CIN125',
      'FOURGON': 'Fourgon C',
      'HEURE_DEPART': '07:30',
      'KILOMETRAGE_DEPART': 18000,
      'HEURE_RETOUR': '15:30',
      'KILOMETRAGE_RETOUR': 18550,
      'NBR_PASSAGES': 12,
    });
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS TP_TOURNES');
  }
}
