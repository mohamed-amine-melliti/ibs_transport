import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'api_config.dart';
import '../model/auth/login_request.dart';
import '../model/auth/login_response.dart';
import '../model/tourne/tourne_response.dart';
import '../model/passage/passage_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  static ApiClient create() {
    final dio = Dio();
    dio.options.connectTimeout = Duration(milliseconds: ApiConfig.connectTimeout);
    dio.options.receiveTimeout = Duration(milliseconds: ApiConfig.receiveTimeout);
    
    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    
    return ApiClient(dio);
  }

  // Authentication
  @POST(ApiConfig.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  // Tournes
  @GET(ApiConfig.tournes)
  Future<List<TourneResponse>> getTournes();
  
  @GET('${ApiConfig.tournes}/{id}')
  Future<TourneResponse> getTourneById(@Path('id') String id);
  
  // Passages
  @GET('${ApiConfig.passages}/tourne/{tourneId}')
  Future<List<PassageResponse>> getPassagesByTourneId(@Path('tourneId') String tourneId);
  
  @GET('${ApiConfig.passages}/{id}')
  Future<PassageResponse> getPassageById(@Path('id') String id);
  
  // Add more API methods as needed
}