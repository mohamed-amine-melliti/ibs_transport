const String rmRemiseMonnaiesTable = 'RM_REMISE_MONNAIES';

class RmRemiseMonnaieFields {
  static const String referenceId = 'RM_REFERENCE_ID';
  static const String passageId = 'TP_PASSAGE_ID';
  static const String pointStopId = 'TR_POINT_STOP_ID';
  static const String type = 'TYPE';
  static const String montant = 'MONTAN';
  
  static const List<String> allFields = [
    referenceId, passageId, pointStopId, type, montant
  ];
}

class RmRemiseMonnaie {
  final String referenceId;
  final String passageId;
  final String pointStopId;
  final String? type;
  final double? montant;
  
  RmRemiseMonnaie({
    required this.referenceId,
    required this.passageId,
    required this.pointStopId,
    this.type,
    this.montant,
  });
  
  static RmRemiseMonnaie fromJson(Map<String, dynamic> json) => RmRemiseMonnaie(
    referenceId: json[RmRemiseMonnaieFields.referenceId] as String,
    passageId: json[RmRemiseMonnaieFields.passageId] as String,
    pointStopId: json[RmRemiseMonnaieFields.pointStopId] as String,
    type: json[RmRemiseMonnaieFields.type] as String?,
    montant: json[RmRemiseMonnaieFields.montant] as double?,
  );
  
  Map<String, dynamic> toJson() => {
    RmRemiseMonnaieFields.referenceId: referenceId,
    RmRemiseMonnaieFields.passageId: passageId,
    RmRemiseMonnaieFields.pointStopId: pointStopId,
    RmRemiseMonnaieFields.type: type,
    RmRemiseMonnaieFields.montant: montant,
  };
  
  RmRemiseMonnaie copy({
    String? referenceId,
    String? passageId,
    String? pointStopId,
    String? type,
    double? montant,
  }) =>
      RmRemiseMonnaie(
        referenceId: referenceId ?? this.referenceId,
        passageId: passageId ?? this.passageId,
        pointStopId: pointStopId ?? this.pointStopId,
        type: type ?? this.type,
        montant: montant ?? this.montant,
      );
}