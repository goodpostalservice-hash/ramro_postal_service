import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/token_provider.dart';
import '../exceptions/api_exceptions.dart';

class ApiClient {
  static const _needTokenKey = 'needToken';
  static const _defaultTimeout = Duration(seconds: 30);

  final Dio _dio;
  final TokenProvider tokenProvider;
  final Connectivity _connectivity;

  ApiClient({
    required this.tokenProvider,
    Dio? dio,
    Connectivity? connectivity,
    String? baseUrl,
  }) : _dio = dio ?? Dio(_baseOptions(baseUrl ?? dotenv.get('BASE_URL'))),
       _connectivity = connectivity ?? Connectivity() {
    _addInterceptors();
  }

  static BaseOptions _baseOptions(String baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: _defaultTimeout,
      receiveTimeout: _defaultTimeout,
      sendTimeout: _defaultTimeout,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    );
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra[_needTokenKey] != true) {
            return handler.next(options);
          }

          if (_hasAuthorizationHeader(options)) {
            return handler.next(options);
          }

          final token = await tokenProvider.getToken();
          if (token == null || token.isEmpty) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.unknown,
                error: const UnauthorizedException('Token not found'),
              ),
            );
          }

          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('[API] ${options.method} ${_endpointOf(options.uri)}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            final request = response.requestOptions;
            debugPrint(
              '[API] ${response.statusCode} ${request.method} '
              '${_endpointOf(request.uri)}',
            );
            handler.next(response);
          },
          onError: (error, handler) {
            final request = error.requestOptions;
            debugPrint(
              '[API] ERROR ${error.response?.statusCode ?? '-'} '
              '${request.method} ${_endpointOf(request.uri)}',
            );
            handler.next(error);
          },
        ),
      );
    }
  }

  bool _hasAuthorizationHeader(RequestOptions options) {
    return options.headers.keys.any(
      (key) => key.toLowerCase() == HttpHeaders.authorizationHeader,
    );
  }

  String _endpointOf(Uri uri) {
    return uri.path.isEmpty ? '/' : uri.path;
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool needToken = false,
    CancelToken? cancelToken,
    bool checkConnectivity = false,
    List<int> validStatusCodes = const [],
  }) {
    return _safeRequest<T>(
      () => _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _options(needToken: needToken),
      ),
      checkConnectivity: checkConnectivity,
      validStatusCodes: validStatusCodes,
    );
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool needToken = false,
    CancelToken? cancelToken,
    bool checkConnectivity = false,
    List<int> validStatusCodes = const [],
  }) {
    return _safeRequest<T>(
      () => _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _options(needToken: needToken),
      ),
      checkConnectivity: checkConnectivity,
      validStatusCodes: validStatusCodes,
    );
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool needToken = false,
    CancelToken? cancelToken,
    bool checkConnectivity = false,
    List<int> validStatusCodes = const [],
  }) {
    return _safeRequest<T>(
      () => _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _options(needToken: needToken),
      ),
      checkConnectivity: checkConnectivity,
      validStatusCodes: validStatusCodes,
    );
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool needToken = false,
    CancelToken? cancelToken,
    bool checkConnectivity = false,
    List<int> validStatusCodes = const [],
  }) {
    return _safeRequest<T>(
      () => _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _options(needToken: needToken),
      ),
      checkConnectivity: checkConnectivity,
      validStatusCodes: validStatusCodes,
    );
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool needToken = false,
    CancelToken? cancelToken,
    bool checkConnectivity = false,
    List<int> validStatusCodes = const [],
  }) {
    return _safeRequest<T>(
      () => _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _options(needToken: needToken),
      ),
      checkConnectivity: checkConnectivity,
      validStatusCodes: validStatusCodes,
    );
  }

  Future<Response<T>> upload<T>(
    String endpoint, {
    required Map<String, dynamic> fields,
    required Map<String, String> files,
    bool needToken = true,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    bool checkConnectivity = false,
    List<int> validStatusCodes = const [],
  }) async {
    final formData = FormData();

    fields.forEach((key, value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

    for (final file in files.entries) {
      try {
        formData.files.add(
          MapEntry(file.key, await MultipartFile.fromFile(file.value)),
        );
      } on FileSystemException catch (e) {
        throw ApiException('File not found or cannot be read: ${e.path}');
      } catch (_) {
        throw ApiException('Failed to attach file: ${file.key}');
      }
    }

    return _safeRequest<T>(
      () => _dio.post<T>(
        endpoint,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: _options(
          needToken: needToken,
          contentType: Headers.multipartFormDataContentType,
        ),
      ),
      checkConnectivity: checkConnectivity,
      validStatusCodes: validStatusCodes,
    );
  }

  Options _options({required bool needToken, String? contentType}) {
    return Options(contentType: contentType, extra: {_needTokenKey: needToken});
  }

  Future<Response<T>> _safeRequest<T>(
    Future<Response<T>> Function() request, {
    bool checkConnectivity = false,
    List<int> validStatusCodes = const [],
  }) async {
    if (checkConnectivity) {
      final hasInternet = await _hasInternetConnection();
      if (!hasInternet) {
        throw const NoInternetException('No internet connection');
      }
    }

    try {
      final response = await request();

      final statusCode = response.statusCode ?? 0;

      if ((statusCode >= 200 && statusCode < 300) ||
          validStatusCodes.contains(statusCode)) {
        return response;
      }

      throw _handleBadResponse(response);
    } on DioException catch (error) {
      throw _handleDioException(error);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException('Something went wrong: $error');
    }
  }

  Future<bool> _hasInternetConnection() async {
    final results = await _connectivity.checkConnectivity();

    return results.any((result) => result != ConnectivityResult.none);
  }

  ApiException _handleBadResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final message = _extractMessage(response.data);

    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 422:
        return ValidationException(message);
      case 500:
      case 502:
      case 503:
        return ServerException(message);
      default:
        return ApiException(message);
    }
  }

  ApiException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutApiException('Connection timeout');

      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null) {
          return _handleBadResponse(response);
        }
        return const ServerException('Invalid server response');

      case DioExceptionType.cancel:
        return const RequestCancelledException('Request cancelled');

      case DioExceptionType.connectionError:
        return const NoInternetException('Connection error');

      case DioExceptionType.badCertificate:
        return const ApiException('Bad SSL certificate');

      case DioExceptionType.unknown:
        final err = error.error;
        if (err is ApiException) return err;
        return ApiException(error.message ?? 'Unknown network error');
    }
  }

  String _extractMessage(dynamic data) {
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();

      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final firstValue = errors.values.first;
          if (firstValue is List && firstValue.isNotEmpty) {
            return firstValue.first.toString();
          }
          return firstValue.toString();
        }
      }

      final nestedData = data['data'];
      if (nestedData is Map && nestedData.isNotEmpty) {
        return _extractMessage(nestedData);
      }
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return 'Something went wrong';
  }
}
