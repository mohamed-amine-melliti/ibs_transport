class AuthenticateBean {
  final String centreFortId;
  final String login;
  final String password;

  AuthenticateBean({
    required this.centreFortId,
    required this.login,
    required this.password,
  });

  factory AuthenticateBean.fromJson(Map<String, dynamic> json) {
    return AuthenticateBean(
      centreFortId: json['centreFortId'] as String,
      login: json['login'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'centreFortId': centreFortId,
      'login': login,
      'password': password,
    };
  }
}