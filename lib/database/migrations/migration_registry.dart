/// Manages database migrations for the application.
///
/// This registry maintains the list of all database migrations in the order they should be executed.
/// When adding new migrations to this list, please follow these guidelines:
///
/// 1. Add migrations in ascending version order
/// 2. When two migrations share the same version number, their order in this list
///    determines execution order (first in the list = executed first)
/// 3. Use descriptive file names that include the version number (e.g., 0002_add_transaction_indexes.dart)
///
/// The MigrationManager will execute migrations in the exact order defined here.
library;

import '0001_initial_schema.dart';
import '0002_account_net_worth.dart';
// Import other existing migrations
import '0007_rf_passage_status.dart';
import '0008_rf_Tourne_status.dart';
import '0009_rf_objects.dart'; // Add this import
import '0010_tp_tournes.dart'; // Add this import
import '0011_tp_passages.dart'; // Add this import
import '0012_rm_remise_billets.dart'; // Add this import
import '0013_rm_remise_objects.dart'; // Add this import
import '0014_rm_remise_monnaies.dart'; // Add this import
import '0015_rp_reprise_objects.dart'; // Add this import

import '../migration_base.dart';

List<Migration> getMigrations() {
  return [
    InitialSchema(),
    AccountNetWorth(),
    // Other existing migrations
    RfPassageStatusMigration(),
    RfTourneStatusMigration(),
    RfObjectsMigration(), // Add this line
    TpTournesMigration(), // Add this line
    TpPassagesMigration(), // Add this line
    RmRemiseBilletsMigration(), // Add this line
    RmRemiseObjectsMigration(), // Add this line
    RmRemiseMonnaiesMigration(), // Add this line
    RpRepriseObjectsMigration(), // Add this line
  ];
}

/// Returns the highest migration version number across all migrations.
/// Used to determine the current database schema version.
///
/// NOTE: This should return the maximum version number found in any migration,
/// not just the version of the last migration in the list. If migrations aren't
/// added in strict version order, make sure this function still returns the highest version.
int getLatestVersion() {
  final migrations = getMigrations();
  if (migrations.isEmpty) return 1;

  return migrations.fold<int>(
      1, (max, migration) => migration.version > max ? migration.version : max);
}
