import 'package:flutter/material.dart';

const String tpTournesTable = 'TP_TOURNES';

class TpTourneFields {
  static const String tourneId = 'TP_TOURNE_ID';
  static const String statusId = 'RF_STATUS_ID';
  static const String dateJourne = 'MT_DATE_JOURNE';
  static const String libelle = 'LIBELLE';
  static const String chauffeur = 'CHAUFFEUR';
  static const String convoyeur = 'CONVOYEUR';
  static const String convoyeurMatricule = 'CONVOYEUR_MATRECULE';
  static const String convoyeurCin = 'CONVOYEUR_CIN';
  static const String fourgon = 'FOURGON';
  static const String heureDepart = 'HEURE_DEPART';
  static const String kilometrageDepart = 'KILOMETRAGE_DEPART';
  static const String heureRetour = 'HEURE_RETOUR';
  static const String kilometrageRetour = 'KILOMETRAGE_RETOUR';
  static const String nbrPassages = 'NBR_PASSAGES';

  static const List<String> allFields = [
    tourneId,
    statusId,
    dateJourne,
    libelle,
    chauffeur,
    convoyeur,
    convoyeurMatricule,
    convoyeurCin,
    fourgon,
    heureDepart,
    kilometrageDepart,
    heureRetour,
    kilometrageRetour,
    nbrPassages
  ];
}

class TpTourne {
  String? centreFortId;
  String? chauffeur;
  String? convoyeur;
  String? convoyeurCin;
  String? convoyeurMatrecule;
  DateTime? dateJourne;
  String? fourgon;
  TimeOfDay? heureDepart;
  TimeOfDay? heureRetour;
  int? kilometrageDepart;
  int? kilometrageRetour;
  String? libelle;
  int? nbrPassages;
  int? statusId;
  DateTime? timeSynchronise;
  String? tourneId;

  TpTourne({
    this.centreFortId,
    this.chauffeur,
    this.convoyeur,
    this.convoyeurCin,
    this.convoyeurMatrecule,
    this.dateJourne,
    this.fourgon,
    this.heureDepart,
    this.heureRetour,
    this.kilometrageDepart,
    this.kilometrageRetour,
    this.libelle,
    this.nbrPassages,
    this.statusId,
    this.timeSynchronise,
    this.tourneId,
  });

  static TpTourne fromJson(Map<String, dynamic> json) {
    return TpTourne(
      centreFortId: json['centreFortId'],
      chauffeur: json['chauffeur'],
      convoyeur: json['convoyeur'],
      convoyeurCin: json['convoyeurCin'],
      convoyeurMatrecule: json['convoyeurMatrecule'],
      dateJourne: json['dateJourne'] != null
          ? DateTime.tryParse(json['dateJourne'])?.toLocal()
          : null,
      fourgon: json['fourgon'],
      heureDepart: _parseTime(json['heureDepart']),
      heureRetour: _parseTime(json['heureRetour']),
      kilometrageDepart: json['kilometrageDepart'],
      kilometrageRetour: json['kilometrageRetour'],
      libelle: json['libelle'],
      nbrPassages: json['nbrPassages'],
      statusId: json['statusId'],
      timeSynchronise: json['timeSynchronise'] != null
          ? DateTime.tryParse(json['timeSynchronise'])?.toLocal()
          : null,
      tourneId: json['tourneId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      TpTourneFields.tourneId: tourneId,
      TpTourneFields.statusId: statusId,
      TpTourneFields.dateJourne: dateJourne,
      TpTourneFields.libelle: libelle,
      TpTourneFields.chauffeur: chauffeur,
      TpTourneFields.convoyeur: convoyeur,
      TpTourneFields.convoyeurCin: convoyeurCin,
      TpTourneFields.fourgon: fourgon,
      TpTourneFields.heureDepart: heureDepart,
      TpTourneFields.kilometrageDepart: kilometrageDepart,
      TpTourneFields.heureRetour: heureRetour,
      TpTourneFields.kilometrageRetour: kilometrageRetour,
      TpTourneFields.nbrPassages: nbrPassages,
    };
  }

  static TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || !timeString.contains(":")) return null;
    try {
      final parts = timeString.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}
