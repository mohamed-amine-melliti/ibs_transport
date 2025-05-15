const String rpRepriseObjectsTable = 'RP_REPRISE_OBJECTS';

class RpRepriseObjectFields {
  static const String referenceId = 'RP_REFERENCE_ID';
  static const String passageId = 'TP_PASSAGE_ID';
  static const String tourneId = 'TP_TOURNE_ID';
  static const String pointStopId = 'TR_POINT_STOP_ID';
  static const String objectId = 'RF_OBJECT_ID';
  static const String montant = 'MONTANT';
  static const String quantite = 'QUANTITE';
  
  static const List<String> allFields = [
    referenceId, passageId, tourneId, pointStopId, objectId, montant, quantite
  ];
}

class RpRepriseObject {
  final String referenceId;
  final String passageId;
  final String tourneId;
  final String pointStopId;
  final String? objectId;
  final double? montant;
  final int? quantite;
  
  RpRepriseObject({
    required this.referenceId,
    required this.passageId,
    required this.tourneId,
    required this.pointStopId,
    this.objectId,
    this.montant,
    this.quantite,
  });
  
  static RpRepriseObject fromJson(Map<String, dynamic> json) => RpRepriseObject(
    referenceId: json[RpRepriseObjectFields.referenceId] as String,
    passageId: json[RpRepriseObjectFields.passageId] as String,
    tourneId: json[RpRepriseObjectFields.tourneId] as String,
    pointStopId: json[RpRepriseObjectFields.pointStopId] as String,
    objectId: json[RpRepriseObjectFields.objectId] as String?,
    montant: json[RpRepriseObjectFields.montant] as double?,
    quantite: json[RpRepriseObjectFields.quantite] as int?,
  );
  
  Map<String, dynamic> toJson() => {
    RpRepriseObjectFields.referenceId: referenceId,
    RpRepriseObjectFields.passageId: passageId,
    RpRepriseObjectFields.tourneId: tourneId,
    RpRepriseObjectFields.pointStopId: pointStopId,
    RpRepriseObjectFields.objectId: objectId,
    RpRepriseObjectFields.montant: montant,
    RpRepriseObjectFields.quantite: quantite,
  };
  
  RpRepriseObject copy({
    String? referenceId,
    String? passageId,
    String? tourneId,
    String? pointStopId,
    String? objectId,
    double? montant,
    int? quantite,
  }) =>
      RpRepriseObject(
        referenceId: referenceId ?? this.referenceId,
        passageId: passageId ?? this.passageId,
        tourneId: tourneId ?? this.tourneId,
        pointStopId: pointStopId ?? this.pointStopId,
        objectId: objectId ?? this.objectId,
        montant: montant ?? this.montant,
        quantite: quantite ?? this.quantite,
      );
}