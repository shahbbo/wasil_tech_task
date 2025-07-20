import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 3000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 3000);

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionException('Connection timeout');
      case DioExceptionType.connectionError:
        return const ConnectionException('No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return const ServerException('Server error');
          } else if (statusCode >= 400) {
            return ServerException(
              error.response?.data?['message'] ?? 'Client error',
            );
          }
        }
        return const ServerException('Unknown server error');
      case DioExceptionType.cancel:
        return const ServerException('Request cancelled');
      case DioExceptionType.unknown:
        return const ServerException('Unknown error occurred');
      default:
        return const ServerException('Unexpected error');
    }
  }
}
