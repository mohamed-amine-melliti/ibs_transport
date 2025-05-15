import 'package:intl/intl.dart';

const String tpPassagesTable = 'TP_PASSAGES';

class TpPassageFields {
  static const String passageId = 'TP_PASSAGE_ID';
  static const String pointStopId = 'TR_POINT_STOP_ID';
  static const String tourneId = 'TP_TOURNE_ID';
  static const String statusId = 'RF_STATUS_ID';
  static const String resultatId = 'RF_RESULTAT_ID';
  static const String clientId = 'TR_CLIENT_ID';
  static const String dateJourne = 'MT_DATE_JOURNE';
  static const String pointStopCode = 'POINT_STOP_CODE';
  static const String pointStopLibelle = 'POINT_STOP_LIBELLE';
  static const String clientLibelle = 'CLIENT_LIBELLE';
  static const String ordre = 'ORDRE';
  static const String beneficierNature = 'BENEFICIER_NATURE';
  static const String pointStopDestLibelle = 'POINT_STOP_DEST_LIBELLE';
  static const String ordrePassage = 'ORDRE_PASSAGE';
  static const String conventionNature = 'CONVENTION_NATURE';
  static const String interventionNature = 'INTERVENTION_NATURE';
  static const String heureIntervention = 'HEURE_INTERVENTION';
  static const String interventionLibelle = 'INTERVENTION_LIBELLE';
  static const String nbrAlimBillet = 'NBR_ALIM_BILLET';
  static const String nbrAlimMonnaie = 'NBR_ALIM_MONNAIE';
  static const String nbrRemiseObjet = 'NBR_REMISE_OBJET';
  static const String nbrRetourObjet = 'NBR_RETOUR_OBJET';
  
  static const List<String> allFields = [
    passageId, pointStopId, tourneId, statusId, resultatId, clientId, dateJourne,
    pointStopCode, pointStopLibelle, clientLibelle, ordre, beneficierNature,
    pointStopDestLibelle, ordrePassage, conventionNature, interventionNature,
    heureIntervention, interventionLibelle, nbrAlimBillet, nbrAlimMonnaie,
    nbrRemiseObjet, nbrRetourObjet
  ];
}

class TpPassage {
  final String passageId;
  final String pointStopId;
  final String tourneId;
  final int? statusId;
  final int? resultatId;
  final String? clientId;
  final DateTime dateJourne;
  final String pointStopCode;
  final String pointStopLibelle;
  final String clientLibelle;
  final int? ordre;
  final String beneficierNature;
  final String? pointStopDestLibelle;
  final String ordrePassage;
  final String conventionNature;
  final String interventionNature;
  final String? heureIntervention;
  final String? interventionLibelle;
  final int nbrAlimBillet;
  final int nbrAlimMonnaie;
  final int nbrRemiseObjet;
  final int nbrRetourObjet;
  
  TpPassage({
    required this.passageId,
    required this.pointStopId,
    required this.tourneId,
    this.statusId,
    this.resultatId,
    this.clientId,
    required this.dateJourne,
    required this.pointStopCode,
    required this.pointStopLibelle,
    required this.clientLibelle,
    this.ordre,
    required this.beneficierNature,
    this.pointStopDestLibelle,
    required this.ordrePassage,
    required this.conventionNature,
    required this.interventionNature,
    this.heureIntervention,
    this.interventionLibelle,
    required this.nbrAlimBillet,
    required this.nbrAlimMonnaie,
    required this.nbrRemiseObjet,
    required this.nbrRetourObjet,
  });
  
  static TpPassage fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return TpPassage(
      passageId: json[TpPassageFields.passageId] as String,
      pointStopId: json[TpPassageFields.pointStopId] as String,
      tourneId: json[TpPassageFields.tourneId] as String,
      statusId: json[TpPassageFields.statusId] as int?,
      resultatId: json[TpPassageFields.resultatId] as int?,
      clientId: json[TpPassageFields.clientId] as String?,
      dateJourne: dateFormat.parse(json[TpPassageFields.dateJourne] as String),
      pointStopCode: json[TpPassageFields.pointStopCode] as String,
      pointStopLibelle: json[TpPassageFields.pointStopLibelle] as String,
      clientLibelle: json[TpPassageFields.clientLibelle] as String,
      ordre: json[TpPassageFields.ordre] as int?,
      beneficierNature: json[TpPassageFields.beneficierNature] as String,
      pointStopDestLibelle: json[TpPassageFields.pointStopDestLibelle] as String?,
      ordrePassage: json[TpPassageFields.ordrePassage] as String,
      conventionNature: json[TpPassageFields.conventionNature] as String,
      interventionNature: json[TpPassageFields.interventionNature] as String,
      heureIntervention: json[TpPassageFields.heureIntervention] as String?,
      interventionLibelle: json[TpPassageFields.interventionLibelle] as String?,
      nbrAlimBillet: json[TpPassageFields.nbrAlimBillet] as int,
      nbrAlimMonnaie: json[TpPassageFields.nbrAlimMonnaie] as int,
      nbrRemiseObjet: json[TpPassageFields.nbrRemiseObjet] as int,
      nbrRetourObjet: json[TpPassageFields.nbrRetourObjet] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      TpPassageFields.passageId: passageId,
      TpPassageFields.pointStopId: pointStopId,
      TpPassageFields.tourneId: tourneId,
      TpPassageFields.statusId: statusId,
      TpPassageFields.resultatId: resultatId,
      TpPassageFields.clientId: clientId,
      TpPassageFields.dateJourne: dateFormat.format(dateJourne),
      TpPassageFields.pointStopCode: pointStopCode,
      TpPassageFields.pointStopLibelle: pointStopLibelle,
      TpPassageFields.clientLibelle: clientLibelle,
      TpPassageFields.ordre: ordre,
      TpPassageFields.beneficierNature: beneficierNature,
      TpPassageFields.pointStopDestLibelle: pointStopDestLibelle,
      TpPassageFields.ordrePassage: ordrePassage,
      TpPassageFields.conventionNature: conventionNature,
      TpPassageFields.interventionNature: interventionNature,
      TpPassageFields.heureIntervention: heureIntervention,
      TpPassageFields.interventionLibelle: interventionLibelle,
      TpPassageFields.nbrAlimBillet: nbrAlimBillet,
      TpPassageFields.nbrAlimMonnaie: nbrAlimMonnaie,
      TpPassageFields.nbrRemiseObjet: nbrRemiseObjet,
      TpPassageFields.nbrRetourObjet: nbrRetourObjet,
    };
  }
  
  TpPassage copy({
    String? passageId,
    String? pointStopId,
    String? tourneId,
    int? statusId,
    int? resultatId,
    String? clientId,
    DateTime? dateJourne,
    String? pointStopCode,
    String? pointStopLibelle,
    String? clientLibelle,
    int? ordre,
    String? beneficierNature,
    String? pointStopDestLibelle,
    String? ordrePassage,
    String? conventionNature,
    String? interventionNature,
    String? heureIntervention,
    String? interventionLibelle,
    int? nbrAlimBillet,
    int? nbrAlimMonnaie,
    int? nbrRemiseObjet,
    int? nbrRetourObjet,
  }) =>
      TpPassage(
        passageId: passageId ?? this.passageId,
        pointStopId: pointStopId ?? this.pointStopId,
        tourneId: tourneId ?? this.tourneId,
        statusId: statusId ?? this.statusId,
        resultatId: resultatId ?? this.resultatId,
        clientId: clientId ?? this.clientId,
        dateJourne: dateJourne ?? this.dateJourne,
        pointStopCode: pointStopCode ?? this.pointStopCode,
        pointStopLibelle: pointStopLibelle ?? this.pointStopLibelle,
        clientLibelle: clientLibelle ?? this.clientLibelle,
        ordre: ordre ?? this.ordre,
        beneficierNature: beneficierNature ?? this.beneficierNature,
        pointStopDestLibelle: pointStopDestLibelle ?? this.pointStopDestLibelle,
        ordrePassage: ordrePassage ?? this.ordrePassage,
        conventionNature: conventionNature ?? this.conventionNature,
        interventionNature: interventionNature ?? this.interventionNature,
        heureIntervention: heureIntervention ?? this.heureIntervention,
        interventionLibelle: interventionLibelle ?? this.interventionLibelle,
        nbrAlimBillet: nbrAlimBillet ?? this.nbrAlimBillet,
        nbrAlimMonnaie: nbrAlimMonnaie ?? this.nbrAlimMonnaie,
        nbrRemiseObjet: nbrRemiseObjet ?? this.nbrRemiseObjet,
        nbrRetourObjet: nbrRetourObjet ?? this.nbrRetourObjet,
      );
}