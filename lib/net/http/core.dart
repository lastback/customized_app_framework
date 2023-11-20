import 'dart:async';
import 'dart:io';
import '../../env.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../log/customized_log.dart';
import 'printer.dart';
import 'env.dart';

abstract class HttpCore {
  /// 请求服务器地址
  /// ***
  /// [HttpCore]
  /// ***
  String get baseUrl;

  /// 代理服务器地址
  /// ***
  /// [HttpCore]
  /// ***
  String get proxyUrl => 'localhost:8888';

  BaseOptions? get options;

  @protected
  late final dio = Dio(options);

  final String method;

  final String host;

  final String path;

  Duration? timeout;

  Map<String, dynamic>? headers;

  EnumHttpState _state = EnumHttpState.idle;

  /// 当前请求的状态
  EnumHttpState get state => _state;

  String get logTag => '';

  @protected
  late final logger = CustomizedLogger(
    printTag: logTag,
    printTime: false,
    // noBoxingByDefault: true,
  );

  /// `HTTP core`
  /// - https://github.com/cfug/dio/blob/main/dio/README-ZH.md
  /// ***
  /// [HttpCore]
  /// ***
  HttpCore({
    required this.method,
    required this.host,
    required this.path,
    this.timeout = const Duration(seconds: 3),
    this.headers,
  }) {
    dio.interceptors.add(PrettyDioLogger(
      printTag: logTag,
      requestHeader: true,
      logPrint: logIt,
    ));
  }

  @protected
  setProxy() async {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (uri) {
          // 将请求代理至 localhost:8888。
          // 请注意，代理会在你正在运行应用的设备上生效，而不是在宿主平台生效。
          return 'PROXY $proxyUrl';
        };
        return client;
      },
    );
  }

  /// 执行http请求
  /// - may throw ex
  ///
  /// 参数：
  /// - queryParameters `Map<String, dynamic>` 请求参数
  Future<dynamic> apply({Map<String, dynamic>? queryParameters}) async {
    try {
      if (_state == EnumHttpState.busy) {
        logger.w('state = $_state');
        return null;
      } else {
        _state = EnumHttpState.busy;

        final Response response = method == HttpMethod.kGet
            ? await dio.get(
                path,
                queryParameters: queryParameters,
              )
            : await dio.post(
                path,
                queryParameters: queryParameters,
              );
        var data = processResponse(response: response);

        _state = EnumHttpState.success;
        return data;
      }
    } on TimeoutException {
      _state = EnumHttpState.timeout;
      rethrow;
    } catch (e) {
      _state = EnumHttpState.fail;
      rethrow;
    }
  }

  @protected
  dynamic processResponse({required Response response}) {
    var data = response.data;
    if (response.statusCode == 200 && data != null) {
      return response.data;
    } else {
      throw '${response.statusCode}';
    }
  }
}
