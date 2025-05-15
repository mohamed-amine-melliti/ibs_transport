const String rfObjectsTable = 'RF_OBJECTS';

class RfObjectFields {
  static const String id = 'RF_OBJECT_ID';
  static const String libelle = 'LIBELLE';
  
  static const List<String> allFields = [id, libelle];
}

class RfObject {
  final String id;
  final String libelle;
  
  RfObject({
    required this.id,
    required this.libelle,
  });
  
  static RfObject fromJson(Map<String, dynamic> json) => RfObject(
    id: json[RfObjectFields.id] as String,
    libelle: json[RfObjectFields.libelle] as String,
  );
  
  Map<String, dynamic> toJson() => {
    RfObjectFields.id: id,
    RfObjectFields.libelle: libelle,
  };
  
  RfObject copy({
    String? id,
    String? libelle,
  }) =>
      RfObject(
        id: id ?? this.id,
        libelle: libelle ?? this.libelle,
      );
}