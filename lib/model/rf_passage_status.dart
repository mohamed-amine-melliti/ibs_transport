const String rfPassageStatusTable = 'RF_PASSAGE_STATUS';

class RfPassageStatusFields {
  static const String id = 'RF_STATUS_ID';
  static const String libelle = 'LIBELLE';
  
  static const List<String> allFields = [id, libelle];
}

class RfPassageStatus {
  final int id;
  final String libelle;
  
  RfPassageStatus({
    required this.id,
    required this.libelle,
  });
  
  static RfPassageStatus fromJson(Map<String, dynamic> json) => RfPassageStatus(
    id: json[RfPassageStatusFields.id] as int,
    libelle: json[RfPassageStatusFields.libelle] as String,
  );
  
  Map<String, dynamic> toJson() => {
    RfPassageStatusFields.id: id,
    RfPassageStatusFields.libelle: libelle,
  };
  
  RfPassageStatus copy({
    int? id,
    String? libelle,
  }) =>
      RfPassageStatus(
        id: id ?? this.id,
        libelle: libelle ?? this.libelle,
      );
}