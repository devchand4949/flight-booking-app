import 'package:dio/dio.dart';
import 'package:flightbooking/core/error/error_handler.dart';
import 'package:flutter/cupertino.dart';

class ApiService {

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late final Dio dio;

  ApiService._internal() {

    dio = Dio(
      BaseOptions(
        baseUrl: "https://your-api-url.com/api/",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<dynamic> getApi(String endPoint, {
    Map<String, dynamic>? queryParameters,
  }) async {

    try {

      final response = await dio.get(
        endPoint,
        queryParameters: queryParameters,
      );

      return response.data;

    } on DioException catch (e) {

      debugPrint("GET ERROR => ${e.message}");

      rethrow;
    }
  }
  /// POST API
  Future<dynamic> postApi(String endPoint, Map<String, dynamic> body,) async {
    try {
      Response response = await dio.post(
        endPoint,
        data: body,
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(ErrorHandler().handleError(e));
    }
  }

  /// PUT API
  Future<dynamic> putApi(String endPoint, Map<String, dynamic> body,) async {
    try {
      Response response = await dio.put(
        endPoint,
        data: body,
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(ErrorHandler().handleError(e));
    }
  }

  /// DELETE API
  Future<dynamic> deleteApi(String endPoint) async {
    try {
      Response response = await dio.delete(endPoint);

      return response.data;
    } on DioException catch (e) {
      throw Exception(ErrorHandler().handleError(e));
    }
  }

  /// ERROR HANDLE
}