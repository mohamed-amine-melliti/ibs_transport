class ApiConfigModel {
  final String centreFortId;
  final String dateJourne;
  final String equipementId;
  final String login;
  final String password;
  
  ApiConfigModel({
    required this.centreFortId,
    required this.dateJourne,
    required this.equipementId,
    required this.login,
    required this.password,
  });
  
  factory ApiConfigModel.fromJson(Map<String, dynamic> json) {
    return ApiConfigModel(
      centreFortId: json['centreFortId'] ?? '',
      dateJourne: json['dateJourne'] ?? '',
      equipementId: json['equipementId'] ?? '',
      login: json['login'] ?? '',
      password: json['password'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'centreFortId': centreFortId,
      'dateJourne': dateJourne,
      'equipementId': equipementId,
      'login': login,
      'password': password,
    };
  }
}