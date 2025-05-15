const String rmRemiseObjectsTable = 'RM_REMISE_OBJECTS';

class RmRemiseObjectFields {
  static const String referenceId = 'RM_REFERENCE_ID';
  static const String passageId = 'TP_PASSAGE_ID';
  static const String pointStopId = 'TR_POINT_STOP_ID';
  static const String objectId = 'RF_OBJECT_ID';
  static const String isRetour = 'IS_RETOUR';
  
  static const List<String> allFields = [
    referenceId, passageId, pointStopId, objectId, isRetour
  ];
}

class RmRemiseObject {
  final String referenceId;
  final String passageId;
  final String pointStopId;
  final String? objectId;
  final bool? isRetour;
  
  RmRemiseObject({
    required this.referenceId,
    required this.passageId,
    required this.pointStopId,
    this.objectId,
    this.isRetour,
  });
  
  static RmRemiseObject fromJson(Map<String, dynamic> json) => RmRemiseObject(
    referenceId: json[RmRemiseObjectFields.referenceId] as String,
    passageId: json[RmRemiseObjectFields.passageId] as String,
    pointStopId: json[RmRemiseObjectFields.pointStopId] as String,
    objectId: json[RmRemiseObjectFields.objectId] as String?,
    isRetour: json[RmRemiseObjectFields.isRetour] == null 
        ? null 
        : json[RmRemiseObjectFields.isRetour] == 1,
  );
  
  Map<String, dynamic> toJson() => {
    RmRemiseObjectFields.referenceId: referenceId,
    RmRemiseObjectFields.passageId: passageId,
    RmRemiseObjectFields.pointStopId: pointStopId,
    RmRemiseObjectFields.objectId: objectId,
    RmRemiseObjectFields.isRetour: isRetour == null ? null : (isRetour! ? 1 : 0),
  };
  
  RmRemiseObject copy({
    String? referenceId,
    String? passageId,
    String? pointStopId,
    String? objectId,
    bool? isRetour,
  }) =>
      RmRemiseObject(
        referenceId: referenceId ?? this.referenceId,
        passageId: passageId ?? this.passageId,
        pointStopId: pointStopId ?? this.pointStopId,
        objectId: objectId ?? this.objectId,
        isRetour: isRetour ?? this.isRetour,
      );
}