import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logarte/logarte.dart';
import '../utils/logarte_util.dart';
import '../utils/storage_util.dart';
import '../utils/utils.dart';
import '../values/const_keys.dart';
import 'app_response_model.dart';
import 'http_config.dart';

class SApi {
  final dio = createDio();
  String _token = "";
  String _apiKey = HttpConfig.apiKey;
  Completer<bool>? _refreshCompleter;
  bool _isRefreshingToken = false;

  SApi._internal();

  static final _singleton = SApi._internal();
  final StreamController<bool> _logoutController =
      StreamController<bool>.broadcast();

  Stream<bool> get logoutStream => _logoutController.stream;

  factory SApi() => _singleton;

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: HttpConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        //30 secs
        receiveTimeout: const Duration(seconds: 10),
        //30 secs
        sendTimeout: const Duration(seconds: 10),
        //20secs
      ),
    );
    dio.interceptors.clear();
    dio.interceptors.addAll({ErrorInterceptor(dio)});
    dio.interceptors.add(HeaderInterceptor());
    dio.interceptors.add(LogarteDioInterceptor(logarte));
    dio.interceptors.addAll({
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (v) {
          log(v.toString());
        },
      ),
    });
    return dio;
  }

  String get token => _token;

  set token(String? value) {
    if (value != null && value.isNotEmpty) {
      _token = value;
    }
  }

  String get apiKey => _apiKey;

  set apiKey(String? value) {
    if (value != null && value.isNotEmpty) {
      _apiKey = value;
    }
  }

  void clearToken() {
    _token = "";
  }

  void clearApiKey() {
    _clearTokens();
  }

  Future<bool> _refreshToken() async {
    if (_isRefreshingToken && _refreshCompleter != null) {
      return await _refreshCompleter!.future;
    }

    _isRefreshingToken = true;
    _refreshCompleter = Completer<bool>();

    try {
      String? refreshToken = await _getRefreshToken();

      if (refreshToken == null) {
        _refreshCompleter?.complete(false);
        _isRefreshingToken = false;
        _refreshCompleter = null;
        return false;
      }
      await _addRequestAndAuthInterceptor(
        addRequestInterceptor: false,
        addAuthInterceptor: false,
      );

      Response response = await dio.post(
        dio.options.baseUrl + HttpConfig.refreshToken,
        data: {"refresh_token": refreshToken},
      );

      if (response.statusCode == 200) {
        await _saveTokens(
          response.data['payload']["access_token"],
          response.data['payload']["refresh_token"],
        );
        _refreshCompleter?.complete(true);
        _isRefreshingToken = false;
        _refreshCompleter = null;
        return true;
      }
    } catch (e) {
      _refreshCompleter?.complete(false);
    } finally {
      if (_isRefreshingToken) {
        _isRefreshingToken = false;
        if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
          _refreshCompleter?.complete(false);
        }
        _refreshCompleter = null;
      }
    }

    return false;
  }

  void _forceLogout() async {
    await _clearTokens();
    SStorageUtil.deleteAuthData();
    _logoutController.add(true); // Notify Bloc to log out
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await SStorageUtil.saveAuthData(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> _clearTokens() async {
    SStorageUtil.deleteAuthData();
  }

  Future<String?> _getAccessToken() async {
    return SStorageUtil.getData<String?>(key: SConstKeys.accessToken);
  }

  Future<String?> _getRefreshToken() async {
    return SStorageUtil.getData(key: SConstKeys.refreshToken);
  }

  ///[GET] We will use this method in order to process get requests
  Future<AppResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? baseUrl,
    void Function(int, int)? onReceiveProgress,
    bool addRequestInterceptor = false,
    bool addAuthInterceptor = false,
  }) async {
    await _addRequestAndAuthInterceptor(
      addRequestInterceptor: addRequestInterceptor,
      addAuthInterceptor: addAuthInterceptor,
    );
    SUtils.logPrint("THIS IS QUERY PARAMS=>$queryParameters");

    try {
      var response = await dio.get<Map<String, dynamic>?>(
        (baseUrl ?? dio.options.baseUrl) + path,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        options: options,
        queryParameters: queryParameters,
      );

      return AppResponse.fromJson(response.data ?? {});
    } on DioErrorException catch (e) {
      return AppResponse.withError(message: e.errorResponse.message);
    } on UnAuthorizedException catch (e) {
      if (addAuthInterceptor) {
        bool success = await _refreshToken();
        if (success) {
          try {
            await _addRequestAndAuthInterceptor(
              addAuthInterceptor: addAuthInterceptor,
              addRequestInterceptor: addRequestInterceptor,
            );
            var response = await dio.get(
              (baseUrl ?? dio.options.baseUrl) + path,
              onReceiveProgress: onReceiveProgress,
              cancelToken: cancelToken,
              options: options,
              queryParameters: queryParameters,
            );

            return AppResponse.fromJson(response.data ?? {});
          } catch (e) {
            SUtils.logPrint("TOKEN REFRESH FAILED : $e");
            return AppResponse.withError(
              message: e.toString(),
              // error: HttpStatus.internalServerError,
            );
          }
        } else {
          _forceLogout();
          return AppResponse.withError(
            message: "UnAuthorized",
            // error: HttpStatus.unauthorized,
          );
        }
      } else {
        return AppResponse.withError(message: e.errorResponse.message);
      }
    } catch (e) {
      log(e.toString());
      return AppResponse.withError(
        message: e.toString(),
        // error: HttpStatus.internalServerError,
      );
    }
  }

  ///[POST] We will use this method in order to process post requests
  Future<AppResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? baseUrl,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool addRequestInterceptor = false,
    bool addAuthInterceptor = true,
  }) async {
    await _addRequestAndAuthInterceptor(
      addRequestInterceptor: addRequestInterceptor,
      addAuthInterceptor: addAuthInterceptor,
    );

    try {
      final response = await dio.post<Map<String, dynamic>?>(
        (baseUrl ?? dio.options.baseUrl) + path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return AppResponse.fromJson(response.data ?? {});
    } on DioErrorException catch (e) {
      return AppResponse.withError(message: e.errorResponse.message);
    } on UnAuthorizedException catch (e) {
      if (addAuthInterceptor) {
        bool success = await _refreshToken();
        if (success) {
          try {
            await _addRequestAndAuthInterceptor(
              addAuthInterceptor: addAuthInterceptor,
              addRequestInterceptor: addRequestInterceptor,
            );
            final response = await dio.post<Map<String, dynamic>?>(
              (baseUrl ?? dio.options.baseUrl) + path,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
              onSendProgress: onSendProgress,
            );
            return AppResponse.fromJson(response.data ?? {});
          } catch (e) {
            SUtils.logPrint("TOKEN REFRESH FAILED : $e");
            return AppResponse.withError(message: e.toString());
          }
        } else {
          _forceLogout();
          return AppResponse.withError(message: "UnAuthorized");
        }
      } else {
        return AppResponse.withError(message: e.errorResponse.message);
      }
    } catch (e) {
      SUtils.logPrint("POST ERROR: $e");
      return AppResponse.withError(message: "Something went wrong");
    }
  }

  ///[PATCH] We will use this method in order to process post requests
  Future<AppResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? baseUrl,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool addRequestInterceptor = false,
    bool addAuthInterceptor = false,
  }) async {
    await _addRequestAndAuthInterceptor(
      addRequestInterceptor: addRequestInterceptor,
      addAuthInterceptor: addAuthInterceptor,
    );
    try {
      final response = await dio.patch<Map<String, dynamic>?>(
        (baseUrl ?? dio.options.baseUrl) + path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return AppResponse.fromJson(response.data ?? {});
    } on DioErrorException catch (e) {
      return AppResponse.withError(message: e.errorResponse.message);
    } on UnAuthorizedException catch (e) {
      if (addAuthInterceptor) {
        bool success = await _refreshToken();
        if (success) {
          try {
            await _addRequestAndAuthInterceptor(
              addAuthInterceptor: addAuthInterceptor,
              addRequestInterceptor: addRequestInterceptor,
            );
            final response = await dio.patch<Map<String, dynamic>?>(
              (baseUrl ?? dio.options.baseUrl) + path,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
              onSendProgress: onSendProgress,
            );
            return AppResponse.fromJson(response.data ?? {});
          } catch (e) {
            SUtils.logPrint("TOKEN REFRESH FAILED : $e");
            return AppResponse.withError(message: e.toString());
          }
        } else {
          _forceLogout();
          return AppResponse.withError(message: "UnAuthorized");
        }
      } else {
        return AppResponse.withError(message: e.errorResponse.message);
      }
    } catch (e) {
      SUtils.logPrint("PATCH ERROR: $e");
      return AppResponse.withError(message: "Something went wrong");
    }
  }

  ///[PUT] We will use this method in order to process post requests
  Future<AppResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? baseUrl,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool addRequestInterceptor = false,
    bool addAuthInterceptor = false,
  }) async {
    await _addRequestAndAuthInterceptor(
      addRequestInterceptor: addRequestInterceptor,
      addAuthInterceptor: addAuthInterceptor,
    );
    try {
      final response = await dio.put<Map<String, dynamic>?>(
        (baseUrl ?? dio.options.baseUrl) + path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return AppResponse.fromJson(response.data ?? {});
    } on DioErrorException catch (e) {
      return AppResponse.withError(message: e.errorResponse.message);
    } on UnAuthorizedException catch (e) {
      if (addAuthInterceptor) {
        bool success = await _refreshToken();
        if (success) {
          try {
            await _addRequestAndAuthInterceptor(
              addAuthInterceptor: addAuthInterceptor,
              addRequestInterceptor: addRequestInterceptor,
            );
            final response = await dio.put<Map<String, dynamic>?>(
              (baseUrl ?? dio.options.baseUrl) + path,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
            );
            return AppResponse.fromJson(response.data ?? {});
          } catch (e) {
            SUtils.logPrint("TOKEN REFRESH FAILED : $e");
            return AppResponse.withError(message: e.toString());
          }
        } else {
          _forceLogout();
          return AppResponse.withError(message: "UnAuthorized");
        }
      } else {
        return AppResponse.withError(message: e.errorResponse.message);
      }
    } catch (e) {
      SUtils.logPrint("PUT ERROR: $e");
      return AppResponse.withError(message: "Something went wrong");
    }
  }

  ///[DELETE] We will use this method in order to process post requests
  Future<AppResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? baseUrl,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool addRequestInterceptor = true,
    bool addAuthInterceptor = false,
  }) async {
    await _addRequestAndAuthInterceptor(
      addRequestInterceptor: addRequestInterceptor,
      addAuthInterceptor: addAuthInterceptor,
    );
    try {
      final response = await dio.delete<Map<String, dynamic>?>(
        (baseUrl ?? dio.options.baseUrl) + path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return AppResponse.fromJson(response.data ?? {});
    } on DioErrorException catch (e) {
      return AppResponse.withError(message: e.errorResponse.message);
    } on UnAuthorizedException catch (e) {
      if (addAuthInterceptor) {
        bool success = await _refreshToken();
        if (success) {
          try {
            await _addRequestAndAuthInterceptor(
              addAuthInterceptor: addAuthInterceptor,
              addRequestInterceptor: addRequestInterceptor,
            );
            final response = await dio.delete<Map<String, dynamic>?>(
              (baseUrl ?? dio.options.baseUrl) + path,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
            );
            return AppResponse.fromJson(response.data ?? {});
          } catch (e) {
            SUtils.logPrint("TOKEN REFRESH FAILED : $e");
            return AppResponse.withError(message: e.toString());
          }
        } else {
          _forceLogout();
          return AppResponse.withError(message: "UnAuthorized");
        }
      } else {
        return AppResponse.withError(message: e.errorResponse.message);
      }
    } catch (e) {
      SUtils.logPrint("DELETE ERROR: $e");
      return AppResponse.withError(message: "Something went wrong");
    }
  }

  Future<void> _addRequestAndAuthInterceptor({
    required bool addRequestInterceptor,
    required bool addAuthInterceptor,
  }) async {
    final hasRequestInterceptor = dio.interceptors.any(
      (element) => element is RequestInterceptor,
    );
    final hasAuthInterceptor = dio.interceptors.any(
      (element) => element is AuthInterceptor,
    );

    if (hasRequestInterceptor) {
      dio.interceptors.removeWhere((element) => element is RequestInterceptor);
    }
    if (hasAuthInterceptor) {
      dio.interceptors.removeWhere((element) => element is AuthInterceptor);
    }
    if (addRequestInterceptor) {
      dio.interceptors.add(RequestInterceptor(apiKey: _apiKey));
    }
    if (addAuthInterceptor) {
      _token = await _getAccessToken() ?? "";
      SUtils.logPrint("THIS IS THE TOKEN: $_token");
      if (_token.isNotEmpty) {
        dio.interceptors.add(AuthInterceptor(authToken: _token));
      }
    }
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
    }
  }
}

class ErrorResponse {
  final String message;
  final int? statusCode;

  const ErrorResponse({required this.message, this.statusCode = 500});

  factory ErrorResponse.fromMap(Map<String, dynamic> map) {
    return ErrorResponse(
      message: map['message'] ?? 'Something went wrong',
      statusCode: map['error'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'message': message, 'status_code': statusCode};
  }
}

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    return handler.next(options);
  }
}

class ErrorInterceptor extends Interceptor {
  final Dio dio;

  ErrorInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ErrorResponse response;
    try {
      response = ErrorResponse.fromMap(
        (err.response?.data ??
                {
                  'message':
                      err.response?.statusMessage ?? 'Something went wrong',
                })
            as Map<String, dynamic>,
      );
    } catch (_) {
      response = ErrorResponse(message: err.message ?? 'Something went wrong');
    }
    log("ERROR STATUS CODE :: ${err.response?.statusCode ?? 600}");
    log("ERROR MESSAGE :: ${response.message}");

    switch (err.type) {
      case DioExceptionType.badResponse:
        {
          switch (err.response?.statusCode) {
            case 401:
              {
                // if (err.requestOptions.path.contains('token/refresh')) {
                //   throw TokenExpiredException(
                //       errorResponse: response,
                //       requestOptions: err.requestOptions);
                // }
                if (err.requestOptions.path.contains(HttpConfig.login)) {
                  throw DioErrorException(
                    errorResponse: response,
                    requestOptions: err.requestOptions,
                  );
                }

                throw UnAuthorizedException(
                  errorResponse: response,
                  requestOptions: err.requestOptions,
                );
              }

            default:
              throw DioErrorException(
                errorResponse: response,
                requestOptions: err.requestOptions,
              );
          }
        }
      default:
        throw DioErrorException(
          errorResponse: response,
          requestOptions: err.requestOptions,
        );
    }
  }
}

class RequestInterceptor extends Interceptor {
  final String apiKey;

  RequestInterceptor({required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = {'X-API-KEY': apiKey};
    return handler.next(options);
  }
}

class AuthInterceptor extends Interceptor {
  String authToken;

  AuthInterceptor({required this.authToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = {
      'Authorization':
          'Bearer ${"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIwMTljNDM2NS02NDVmLTcyZDQtYmM4Ny05ZjlkMDM5MjA5M2YiLCJqdGkiOiJhNGM4ZjA3ZjJkOGNhMWIxOTJjMjA1ODQ0Njc3MzhmMWE0NzhjOWMyMDBmYzA5YjVjYTIzNDYwZTg5ZGI1NjY3ZTFkZjg5MzI1N2JmNzUxMyIsImlhdCI6MTc3NTE0ODU1NC4yMjY2ODI5MDEzODI0NDYyODkwNjI1LCJuYmYiOjE3NzUxNDg1NTQuMjI2Njg3OTA4MTcyNjA3NDIxODc1LCJleHAiOjE3OTA5NTk3NTQuMjE0MzE0OTM3NTkxNTUyNzM0Mzc1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.nTi0mbjndC3UWCFOEm1aKeeBGHd282juuF5dzE_uucESNNgNF4myX_IOALwuDOmq8tDuVazWpcALZfzU-tDvIyjMzhC1xNGtKA0_-z94ftrNhxWmzQFSzeX1wcczeTWgPRm7vYXhWSPjL4SqlQwemnq2uQSnHLQhenYAqezkJaQW-21GL-4-Gq87pYvAkREcv8pATSZwi7PvgMw4BdDFBEGBuybsVhgbFf35Z6Dmq_0L5neEeN9TvNfTLYWmjKOiI-WE0QGLfj622UlaJK4ivAjmfgic_EkndKR-9eQPGPO99dSG35_GGkGuhAM7eb2eSBfqVylzMp91nhHtYUzcOWnP710qPc75jCWDlHuLUUCqH4-Z9kSfIL8-gzh94MUrYeWyMsHYY_8T1QMC280yEKhFsm285zZEYaR1_PgJviojuzy9iZ4kJWs7d9Rws46ezXqnA_eDUQybZlNOEzYtB6o8tlJcr_HnjQOWrgcy4Vkn7_Gbtn3mBsZKrCB4M4FRLKafCgOAg27Hx3M3RArcha5OK3uttIm4NDDzZNNdIs34EzEOW8yBzKGDgF4U-VUiBFSTSwaiQU6-5zxsQ4bZnLOIqy-x_kKpfutw72RsKgUg0v3P-rS5ZL0yLnsNqfsiMEWGacJAYQ_MT6yaNGbrj3VaPJwtGD3buVbAzIrE5nE"}',
    };
    return handler.next(options);
  }
}

class DioErrorException extends DioException {
  final ErrorResponse errorResponse;

  @override
  String toString() => errorResponse.message;

  DioErrorException({
    required this.errorResponse,
    required super.requestOptions,
  });
}

class UnAuthorizedException extends DioException {
  final ErrorResponse errorResponse;

  @override
  String toString() => errorResponse.message;

  UnAuthorizedException({
    required this.errorResponse,
    required super.requestOptions,
  });
}
