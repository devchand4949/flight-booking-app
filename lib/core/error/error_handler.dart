import 'dart:io';

import 'package:dio/dio.dart';

class ApiException implements Exception {

  final String message;
  final int? statusCode;

  ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class ErrorHandler {

  ApiException handleError(dynamic e) {

    /// NO INTERNET
    if (e is SocketException) {

      return ApiException(
        message: "No internet connection",
      );

    }

    /// DIO ERRORS
    if (e is DioException) {

      /// timeout
      if (e.type == DioExceptionType.connectionTimeout) {
        return ApiException(
          message: "Connection timeout. Please try again.",
        );
      }

      if (e.type == DioExceptionType.receiveTimeout) {
        return ApiException(
          message: "Server taking too long to respond.",
        );
      }

      /// internet issue
      if (e.type == DioExceptionType.connectionError) {
        return ApiException(
          message: "No internet connection",
        );
      }

      /// cancel
      if (e.type == DioExceptionType.cancel) {
        return ApiException(
          message: "Request cancelled",
        );
      }

      /// server response
      if (e.response != null) {

        final data = e.response?.data;

        final apiMessage = data is Map<String, dynamic>
            ? data["error"]
            : null;

        switch (e.response?.statusCode) {

          case 400:
            return ApiException(
              message: apiMessage ?? "Invalid request",
              statusCode: 400,
            );

          case 401:
            return ApiException(
              message: "Session expired. Please login again",
              statusCode: 401,
            );

          case 403:
            return ApiException(
              message: "Access denied",
              statusCode: 403,
            );

          case 404:
            return ApiException(
              message: "Requested data not found",
              statusCode: 404,
            );

          case 500:
            return ApiException(
              message: apiMessage ?? "Server error occurred",
              statusCode: 500,
            );

          default:
            return ApiException(
              message: apiMessage ?? "Something went wrong",
              statusCode: e.response?.statusCode,
            );
        }
      }
    }

    return ApiException(
      message: "Unexpected error occurred",
    );
  }
}