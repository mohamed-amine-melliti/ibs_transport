// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

// Models
import '/model/rf_pda_config.dart';

class RfPdaConfigsMigration extends Migration {
  RfPdaConfigsMigration()
      : super(
          version: 5, // Update this to be higher than your current highest migration version
          description: 'Add RF_PDA_CONFIGS table',
        );

  @override
  Future<void> up(Database db) async {
    // Create the RF_PDA_CONFIGS table
    await db.execute('''
      CREATE TABLE `$rfPdaConfigTable`(
        `${RfPdaConfigFields.id}` NUMERIC(1) PRIMARY KEY,
        `${RfPdaConfigFields.pdaId}` VARCHAR(20) NOT NULL,
        `${RfPdaConfigFields.centreFortId}` VARCHAR(20) NOT NULL
      )
    ''');


       // Insertion des données initiales


     // Insertion des données initiales

     
  }
}