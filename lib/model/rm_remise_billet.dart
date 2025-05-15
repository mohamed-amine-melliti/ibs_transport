const String rmRemiseBilletsTable = 'RM_REMISE_BILLETS';

class RmRemiseBilletFields {
  static const String referenceId = 'RM_REFERENCE_ID';
  static const String passageId = 'TP_PASSAGE_ID';
  static const String pointStopId = 'TR_POINT_STOP_ID';
  static const String type1 = 'TYPE1';
  static const String montant1 = 'MONTANT1';
  static const String type2 = 'TYPE2';
  static const String montant2 = 'MONTANT2';
  static const String montantGlobal = 'MONTANT_GLOBAL';
  
  static const List<String> allFields = [
    referenceId, passageId, pointStopId, type1, montant1, 
    type2, montant2, montantGlobal
  ];
}

class RmRemiseBillet {
  final String referenceId;
  final String passageId;
  final String pointStopId;
  final String? type1;
  final double? montant1;
  final String? type2;
  final double? montant2;
  final double? montantGlobal;
  
  RmRemiseBillet({
    required this.referenceId,
    required this.passageId,
    required this.pointStopId,
    this.type1,
    this.montant1,
    this.type2,
    this.montant2,
    this.montantGlobal,
  });
  
  static RmRemiseBillet fromJson(Map<String, dynamic> json) => RmRemiseBillet(
    referenceId: json[RmRemiseBilletFields.referenceId] as String,
    passageId: json[RmRemiseBilletFields.passageId] as String,
    pointStopId: json[RmRemiseBilletFields.pointStopId] as String,
    type1: json[RmRemiseBilletFields.type1] as String?,
    montant1: json[RmRemiseBilletFields.montant1] as double?,
    type2: json[RmRemiseBilletFields.type2] as String?,
    montant2: json[RmRemiseBilletFields.montant2] as double?,
    montantGlobal: json[RmRemiseBilletFields.montantGlobal] as double?,
  );
  
  Map<String, dynamic> toJson() => {
    RmRemiseBilletFields.referenceId: referenceId,
    RmRemiseBilletFields.passageId: passageId,
    RmRemiseBilletFields.pointStopId: pointStopId,
    RmRemiseBilletFields.type1: type1,
    RmRemiseBilletFields.montant1: montant1,
    RmRemiseBilletFields.type2: type2,
    RmRemiseBilletFields.montant2: montant2,
    RmRemiseBilletFields.montantGlobal: montantGlobal,
  };
  
  RmRemiseBillet copy({
    String? referenceId,
    String? passageId,
    String? pointStopId,
    String? type1,
    double? montant1,
    String? type2,
    double? montant2,
    double? montantGlobal,
  }) =>
      RmRemiseBillet(
        referenceId: referenceId ?? this.referenceId,
        passageId: passageId ?? this.passageId,
        pointStopId: pointStopId ?? this.pointStopId,
        type1: type1 ?? this.type1,
        montant1: montant1 ?? this.montant1,
        type2: type2 ?? this.type2,
        montant2: montant2 ?? this.montant2,
        montantGlobal: montantGlobal ?? this.montantGlobal,
      );
}