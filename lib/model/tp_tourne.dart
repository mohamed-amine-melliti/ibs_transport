import 'package:intl/intl.dart';

const String tpTournesTable = 'TP_TOURNES';

class TpTourneFields {
  static const String id = 'TP_TOURNE_ID';
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
    id, statusId, dateJourne, libelle, chauffeur, convoyeur, 
    convoyeurMatricule, convoyeurCin, fourgon, heureDepart, 
    kilometrageDepart, heureRetour, kilometrageRetour, nbrPassages
  ];
}

class TpTourne {
  final String id;
  final int? statusId;
  final DateTime dateJourne;
  final String? libelle;
  final String? chauffeur;
  final String? convoyeur;
  final String? convoyeurMatricule;
  final String? convoyeurCin;
  final String? fourgon;
  final String? heureDepart;
  final int? kilometrageDepart;
  final String? heureRetour;
  final int? kilometrageRetour;
  final int nbrPassages;
  
  TpTourne({
    required this.id,
    this.statusId,
    required this.dateJourne,
    this.libelle,
    this.chauffeur,
    this.convoyeur,
    this.convoyeurMatricule,
    this.convoyeurCin,
    this.fourgon,
    this.heureDepart,
    this.kilometrageDepart,
    this.heureRetour,
    this.kilometrageRetour,
    required this.nbrPassages,
  });
  
  static TpTourne fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return TpTourne(
      id: json[TpTourneFields.id] as String,
      statusId: json[TpTourneFields.statusId] as int?,
      dateJourne: dateFormat.parse(json[TpTourneFields.dateJourne] as String),
      libelle: json[TpTourneFields.libelle] as String?,
      chauffeur: json[TpTourneFields.chauffeur] as String?,
      convoyeur: json[TpTourneFields.convoyeur] as String?,
      convoyeurMatricule: json[TpTourneFields.convoyeurMatricule] as String?,
      convoyeurCin: json[TpTourneFields.convoyeurCin] as String?,
      fourgon: json[TpTourneFields.fourgon] as String?,
      heureDepart: json[TpTourneFields.heureDepart] as String?,
      kilometrageDepart: json[TpTourneFields.kilometrageDepart] as int?,
      heureRetour: json[TpTourneFields.heureRetour] as String?,
      kilometrageRetour: json[TpTourneFields.kilometrageRetour] as int?,
      nbrPassages: json[TpTourneFields.nbrPassages] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      TpTourneFields.id: id,
      TpTourneFields.statusId: statusId,
      TpTourneFields.dateJourne: dateFormat.format(dateJourne),
      TpTourneFields.libelle: libelle,
      TpTourneFields.chauffeur: chauffeur,
      TpTourneFields.convoyeur: convoyeur,
      TpTourneFields.convoyeurMatricule: convoyeurMatricule,
      TpTourneFields.convoyeurCin: convoyeurCin,
      TpTourneFields.fourgon: fourgon,
      TpTourneFields.heureDepart: heureDepart,
      TpTourneFields.kilometrageDepart: kilometrageDepart,
      TpTourneFields.heureRetour: heureRetour,
      TpTourneFields.kilometrageRetour: kilometrageRetour,
      TpTourneFields.nbrPassages: nbrPassages,
    };
  }
  
  TpTourne copy({
    String? id,
    int? statusId,
    DateTime? dateJourne,
    String? libelle,
    String? chauffeur,
    String? convoyeur,
    String? convoyeurMatricule,
    String? convoyeurCin,
    String? fourgon,
    String? heureDepart,
    int? kilometrageDepart,
    String? heureRetour,
    int? kilometrageRetour,
    int? nbrPassages,
  }) =>
      TpTourne(
        id: id ?? this.id,
        statusId: statusId ?? this.statusId,
        dateJourne: dateJourne ?? this.dateJourne,
        libelle: libelle ?? this.libelle,
        chauffeur: chauffeur ?? this.chauffeur,
        convoyeur: convoyeur ?? this.convoyeur,
        convoyeurMatricule: convoyeurMatricule ?? this.convoyeurMatricule,
        convoyeurCin: convoyeurCin ?? this.convoyeurCin,
        fourgon: fourgon ?? this.fourgon,
        heureDepart: heureDepart ?? this.heureDepart,
        kilometrageDepart: kilometrageDepart ?? this.kilometrageDepart,
        heureRetour: heureRetour ?? this.heureRetour,
        kilometrageRetour: kilometrageRetour ?? this.kilometrageRetour,
        nbrPassages: nbrPassages ?? this.nbrPassages,
      );
}