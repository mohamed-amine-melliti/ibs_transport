const String rfPassageResultatsTable = 'RF_PASSAGE_RESULTATS';

class RfPassageResultatFields {
  static const String id = 'RF_RESULTAT_ID';
  static const String libelle = 'LIBELLE';
  
  static const List<String> allFields = [id, libelle];
}

class RfPassageResultat {
  final int id;
  final String libelle;
  
  RfPassageResultat({
    required this.id,
    required this.libelle,
  });
  
  static RfPassageResultat fromJson(Map<String, dynamic> json) => RfPassageResultat(
    id: json[RfPassageResultatFields.id] as int,
    libelle: json[RfPassageResultatFields.libelle] as String,
  );
  
  Map<String, dynamic> toJson() => {
    RfPassageResultatFields.id: id,
    RfPassageResultatFields.libelle: libelle,
  };
  
  RfPassageResultat copy({
    int? id,
    String? libelle,
  }) =>
      RfPassageResultat(
        id: id ?? this.id,
        libelle: libelle ?? this.libelle,
      );
}