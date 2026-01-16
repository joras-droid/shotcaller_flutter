import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

/// API client using Dio for HTTP requests
/// Configured once and injected throughout the app
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging (remove in production if needed)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    // TODO: Add auth token interceptor here
    // _dio.interceptors.add(AuthInterceptor());
  }

  /// Get Dio instance for making requests
  Dio get dio => _dio;

  /// Set authorization token
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
}

