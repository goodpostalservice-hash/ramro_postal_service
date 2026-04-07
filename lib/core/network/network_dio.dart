import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import '../constants/api_constant.dart';
import '../constants/app_constant.dart';

enum Method { POST, GET, PUT, DELETE, PATCH, POST_JSON }

const baseURL = ApiConstant.baseUrl;

class RestClient extends GetxService {
  late Dio _dio;

  //this is for header
  static header() => {
    'Content-Type': 'application/json',
    'Authorization': "Bearer ${AppConstant.bearerToken.toString()}",
  };

  //this is for header
  static normalHeader() => {'Content-Type': 'application/json'};

  Future<RestClient> init() async {
    print('init: $header');

    _dio = Dio(BaseOptions(baseUrl: baseURL, headers: header()));
    initInterceptors();
    return this;
  }

  void initInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print(
            'REQUEST[${options.method}] => PATH: ${options.path} '
            '=> Request Values: ${options.queryParameters}, => HEADERS: ${options.headers}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (err, handler) {
          print('ERROR[${err.response?.statusCode}]');
          return handler.next(err);
        },
      ),
    );
  }

  Future<dynamic> request(
    String url,
    Method method,
    Map<String, dynamic>? params,
  ) async {
    Response response;

    try {
      if (method == Method.POST) {
        response = await _dio.post(
          url,
          data: FormData.fromMap(params!),
          options: Options(
            headers: {
              "Authorization": "Bearer ${AppConstant.bearerToken.toString()}",
            },
          ),
        );
      } else if (method == Method.POST_JSON) {
        response = await _dio.post(
          url,
          data: params,
          options: Options(
            headers: {
              "Authorization": "Bearer ${AppConstant.bearerToken.toString()}",
            },
          ),
        );
      } else if (method == Method.DELETE) {
        response = await _dio.delete(url);
      } else if (method == Method.PATCH) {
        response = await _dio.patch(url);
      } else {
        response = await _dio.get(
          url,
          queryParameters: params,
          options: Options(
            headers: {
              "Authorization": "Bearer ${AppConstant.bearerToken.toString()}",
            },
          ),
        );
      }

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something Went Wrong");
      }
    } on SocketException {
      throw Exception("No Internet Connection");
    } on FormatException {
      throw Exception("Bad Response Format!");
    } on DioException catch (e) {
      throw Exception(e.response?.data['validation_errors']);
    } catch (e) {
      throw Exception("Something Went Wrong");
    }
  }
}
