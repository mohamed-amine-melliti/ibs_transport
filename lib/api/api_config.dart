class ApiConfig {
  static const String baseUrl = 'http://172.20.20.119:8082/';
  static const String apiDocs = '$baseUrl/api-docs';
  
  // API endpoints
  static const String login = '/auth/login';
  static const String tournes = '/ibs-api/tourne/ouvertureJournee';
  static const String passages = '/passages';
  static const String objects = '/objects';
  // Add more endpoints as needed
}