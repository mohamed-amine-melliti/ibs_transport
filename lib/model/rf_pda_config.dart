import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'base_entity.dart';

const String rfPdaConfigTable = 'RF_PDA_CONFIGS';

class RfPdaConfigFields {
  static const String id = 'RF_PDA_CONFIG_ID';
  static const String pdaId = 'RF_PDA_ID';
  static const String centreFortId = 'TR_CENTRE_FORT_ID';
  static const String centreFortLibelle = 'CENTRE_FORT_LIBELLE';
  static const String apiUrl = 'API_URL';

  static final List<String> allFields = [id, pdaId, centreFortId, centreFortLibelle, apiUrl];
}

class RfPdaConfig {
  final int id;
  final String pdaId;
  final String centreFortId;
  final String centreFortLibelle;
  final String apiUrl;

  RfPdaConfig({
    required this.id,
    required this.pdaId,
    required this.centreFortId,
    required this.centreFortLibelle,
    required this.apiUrl,
  });

  RfPdaConfig copy({
    int? id,
    String? pdaId,
    String? centreFortId,
    String? centreFortLibelle,
    String? apiUrl,
  }) =>
      RfPdaConfig(
        id: id ?? this.id,
        pdaId: pdaId ?? this.pdaId,
        centreFortId: centreFortId ?? this.centreFortId,
        centreFortLibelle: centreFortLibelle ?? this.centreFortLibelle,
        apiUrl: apiUrl ?? this.apiUrl,
      );

  Map<String, dynamic> toMap() => {
        RfPdaConfigFields.id: id,
        RfPdaConfigFields.pdaId: pdaId,
        RfPdaConfigFields.centreFortId: centreFortId,
        RfPdaConfigFields.centreFortLibelle: centreFortLibelle,
        RfPdaConfigFields.apiUrl: apiUrl,
      };

  factory RfPdaConfig.fromMap(Map<String, dynamic> map) => RfPdaConfig(
        id: map[RfPdaConfigFields.id] as int,
        pdaId: map[RfPdaConfigFields.pdaId] as String,
        centreFortId: map[RfPdaConfigFields.centreFortId] as String,
        centreFortLibelle: map[RfPdaConfigFields.centreFortLibelle] as String,
        apiUrl: map[RfPdaConfigFields.apiUrl] as String,
      );

  Map<String, Object?> toJson() => {
        RfPdaConfigFields.id: id,
        RfPdaConfigFields.pdaId: pdaId,
        RfPdaConfigFields.centreFortId: centreFortId,
        RfPdaConfigFields.centreFortLibelle: centreFortLibelle,
        RfPdaConfigFields.apiUrl: apiUrl,
      };

  static RfPdaConfig fromJson(Map<String, Object?> json) => RfPdaConfig(
        id: json[RfPdaConfigFields.id] as int,
        pdaId: json[RfPdaConfigFields.pdaId] as String,
        centreFortId: json[RfPdaConfigFields.centreFortId] as String,
        centreFortLibelle: json[RfPdaConfigFields.centreFortLibelle] as String,
        apiUrl: json[RfPdaConfigFields.apiUrl] as String,
      );
}
