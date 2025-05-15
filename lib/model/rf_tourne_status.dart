const String rfTourneStatusTable = 'RF_TOURNE_STATUS';

class RfTourneStatusFields {
  static const String id = 'RF_STATUS_ID';
  static const String libelle = 'LIBELLE';
  
  static const List<String> allFields = [id, libelle];
}

class RfTourneStatus {
  final int id;
  final String libelle;
  
  RfTourneStatus({
    required this.id,
    required this.libelle,
  });
  
  static RfTourneStatus fromJson(Map<String, dynamic> json) => RfTourneStatus(
    id: json[RfTourneStatusFields.id] as int,
    libelle: json[RfTourneStatusFields.libelle] as String,
  );
  
  Map<String, dynamic> toJson() => {
    RfTourneStatusFields.id: id,
    RfTourneStatusFields.libelle: libelle,
  };
  
  RfTourneStatus copy({
    int? id,
    String? libelle,
  }) =>
      RfTourneStatus(
        id: id ?? this.id,
        libelle: libelle ?? this.libelle,
      );
}