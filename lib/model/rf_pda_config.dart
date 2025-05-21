import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'base_entity.dart';

const String rfPdaConfigTable = 'RF_PDA_CONFIGS';

class RfPdaConfigFields {
  static const String id = 'RF_PDA_CONFIG_ID';
  static const String pdaId = 'RF_PDA_ID';
  static const String centreFortId = 'TR_CENTRE_FORT_ID';
  static const String url = 'url';

  static final List<String> allFields = [id, pdaId, centreFortId, url];
}

class RfPdaConfig {
  final int id;
  final String pdaId;
  final String centreFortId;
  final String? url;

  RfPdaConfig({
    required this.id,
    required this.pdaId,
    required this.centreFortId,
    this.url,
  });

  RfPdaConfig copy({
    int? id,
    String? pdaId,
    String? centreFortId,
    String? url,
  }) =>
      RfPdaConfig(
        id: id ?? this.id,
        pdaId: pdaId ?? this.pdaId,
        centreFortId: centreFortId ?? this.centreFortId,
        url: url ?? this.url,
      );

  Map<String, dynamic> toMap() => {
        RfPdaConfigFields.id: id,
        RfPdaConfigFields.pdaId: pdaId,
        RfPdaConfigFields.centreFortId: centreFortId,
        RfPdaConfigFields.url: url,
      };

  factory RfPdaConfig.fromMap(Map<String, dynamic> map) => RfPdaConfig(
        id: map[RfPdaConfigFields.id] as int,
        pdaId: map[RfPdaConfigFields.pdaId] as String,
        centreFortId: map[RfPdaConfigFields.centreFortId] as String,
        url: map[RfPdaConfigFields.url] as String?,
      );

  Map<String, Object?> toJson() => {
        RfPdaConfigFields.id: id,
        RfPdaConfigFields.pdaId: pdaId,
        RfPdaConfigFields.centreFortId: centreFortId,
        RfPdaConfigFields.url: url,
      };

  static RfPdaConfig fromJson(Map<String, Object?> json) => RfPdaConfig(
        id: json[RfPdaConfigFields.id] as int,
        pdaId: json[RfPdaConfigFields.pdaId] as String,
        centreFortId: json[RfPdaConfigFields.centreFortId] as String,
        url: json[RfPdaConfigFields.url] as String?,
      );
}
