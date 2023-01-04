import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import '../../global/flavor/app_flavor.dart';
import '../../global/utilities/logger.dart';
import 'error_code.dart';
import 'exception.dart';

@singleton
class ApiProvider {
  var dio = Dio(
    BaseOptions(
      connectTimeout: 30000,
      headers: {
        'Content-Type': 'application/json'
      },
      baseUrl: AppFlavor.baseApi,
      // contentType: Headers.jsonContentType,
    ),
  );

  void _addInterceptors(Dio dio) {
    dio
      ..interceptors.clear()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) =>
              _requestInterceptor(options, handler),
        ),
      );
  }

  void _requestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers
        .addAll({'Authorization': 'Bearer ${AppFlavor.openAIApiKey}'});
    handler.next(options);
  }

  Future<dynamic> request({
    String? rawData,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    FormData? formParams,
    required Method method,
    required String url,
  }) async {
    var responseJson = {};
    try {
      _addInterceptors(dio);
      final response = await dio.request(
        url,
        queryParameters: queryParams,
        data: (formParams != null)
            ? formParams
            : (data != null)
                ? data
                : rawData,
        options: Options(
          method: method.name,
          validateStatus: (code) {
            return code! >= 200 && code < 300;
          },
        ),
      );
      LoggerUtils.i(response.data);
      // response.data = {"data": response.data};
      responseJson = _formatRes(
        response.statusCode,
        response.data,
        response.headers,
      );
    } on SocketException {
      throw ErrorException(ErrorCode.NO_NETWORK, 'NO_NETWORK');
    } on DioError catch (e) {
      debugPrint('error = $e');
      if (e.type == DioErrorType.connectTimeout) {
        throw ErrorException(ErrorCode.NO_NETWORK, 'NO_NETWORK');
      }
      throw ErrorException(e.response?.statusCode, e.response?.data['error']);
    }
    return responseJson;
  }

  Future get(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    return await request(
      method: Method.get,
      url: url,
      queryParams: params,
    );
  }

  Future postMultiPart(
    String url,
    FormData formData,
  ) async {
    return await request(
      method: Method.post,
      url: url,
      formParams: formData,
    );
  }

  Future putMultiPart(
    String url,
    FormData formData,
  ) async {
    return await request(
      method: Method.put,
      url: url,
      formParams: formData,
    );
  }

  Future post(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    return await request(
      method: Method.post,
      url: url,
      data: params,
    );
  }

  Future put(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    return await request(
      method: Method.put,
      url: url,
      data: params,
    );
  }

  Future delete(String url, {Map<String, dynamic>? params}) async {
    return await request(
      method: Method.delete,
      url: url,
      data: params,
    );
  }

  Future patch(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    return await request(
      method: Method.patch,
      url: url,
      data: params,
    );
  }

  dynamic _formatRes(int? code, dynamic data, Headers header) {
    switch (code) {
      case ErrorCode.HTTP_OK:
        return data;
      case ErrorCode.HTTP_BAD_REQUEST:
        throw BadRequestException(data['message']);
      case ErrorCode.HTTP_UNAUTHORIZED:
      case ErrorCode.HTTP_FORBIDDEN:
        throw UnauthorisedException(data['message']);
      case ErrorCode.HTTP_INTERNAL_SERVER_ERROR:
      default:
        throw ErrorException(code,
            'Error occured while Communication with Server with StatusCode : $code');
    }
  }
}

enum Method { get, post, patch, put, delete }
