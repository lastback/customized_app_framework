import 'dart:math' as math;
import 'dart:typed_data';
import 'package:dio/dio.dart';

class PrettyDioLogger extends Interceptor {
  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int kInitialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Size in which the Uint8List will be splitted
  static const int chunkSize = 20;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  final void Function(Object object) logPrint;

  /// added by me
  final String printTag;

  PrettyDioLogger({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 90,
    this.compact = true,
    required this.logPrint,
    this.printTag = '',
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String logText = '';
    if (request) {
      // _printRequestHeader(options);
      logText += '\n┌ [${printTag.toUpperCase()}] ${DateTime.now()}\n  Request ║ ${options.method} ║ ${options.uri.toString()}\n';
    }
    if (requestHeader) {
      logText += '\n  Query Parameters = ';
      // _printMapAsTable(options.queryParameters, header: 'Query Parameters');

      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
      requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();

      logText += '$requestHeaders\n└ ';

      // _printMapAsTable(requestHeaders, header: 'Headers');
      // _printMapAsTable(options.extra, header: 'Extras');
    }

    logPrint(logText);

    // if (requestBody && options.method != 'GET') {
    //   final dynamic data = options.data;

    //   if (data != null) {
    //     if (data is Map) _printMapAsTable(options.data as Map?, header: 'Body');
    //     if (data is FormData) {
    //       final formDataMap = <String, dynamic>{}
    //         ..addEntries(data.fields)
    //         ..addEntries(data.files);
    //       _printMapAsTable(formDataMap, header: 'Form data | ${data.boundary}');
    //     } else {
    //       _printBlock(data.toString());
    //     }
    //   }
    // }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String logText = '';
    if (error) {
      final uri = err.requestOptions.uri;

      if (err.type != DioExceptionType.badResponse) {
        logText += '\n┌ [${printTag.toUpperCase()}] ${DateTime.now()}\n  DioError ║ ${err.requestOptions.method} ║ ${uri.toString()}\n';
        // _printBoxed(header: 'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}', text: uri.toString());
        logText += '  status = ${err.response?.statusCode}\n  message = ${err.response?.statusMessage}\n';
        if (err.response != null && err.response?.data != null) {
          // logPrint('╔ ${err.type.toString()}');
          // _printResponse(err.response!);
          logText += '${err.response?.data}';
        }

        logText += '└ ';
        // _printLine('╚');
        // logPrint('');
        logPrint(logText);
      } else {
        logText += '\n┌ [${printTag.toUpperCase()}] ${DateTime.now()}\n  DioError ║ ${err.requestOptions.method} ║ ${uri.toString()}\n';
        logText += '  type = ${err.type}\n  message = ${err.message}\n└ ';
        logPrint(logText);
        // _printBoxed(header: 'DioError ║ ${err.type}', text: err.message);
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // _printResponseHeader(response);
    String logText = '';
    logText +=
        '\n┌ [${printTag.toUpperCase()}] ${DateTime.now()}\n   Response ║ ${response.requestOptions.method} ║ ${response.requestOptions.uri.toString()}\n';

    // if (responseHeader) {
    //   final responseHeaders = <String, String>{};
    //   response.headers.forEach((k, list) => responseHeaders[k] = list.toString());
    //   _printMapAsTable(responseHeaders, header: 'Headers');
    // }

    if (responseBody) {
      logText += '  Body = $response\n└';
      // logPrint('╔ Body');
      // _printResponse(response);
      // logPrint('╚');
    }

    logPrint(logText);
    super.onResponse(response, handler);
  }

  void _printBoxed({String? header, String? text}) {
    //added by me
    // logPrint('');
    // logPrint('╔ $header ');
    // logPrint('$text');
    // logPrint('╚');

    logPrint('[${printTag.toUpperCase()}] ${DateTime.now()}\n╔ $header\n$text\n╚');
  }

  void _printResponse(Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        ///直接打印会error
        logPrint('${response.data}');
      } else if (response.data is Uint8List) {
        logPrint('${_indent()}[');
        _printUint8List(response.data as Uint8List);
        logPrint('${_indent()}]');
      } else if (response.data is List) {
        logPrint('${_indent()}[');
        _printList(response.data as List);
        logPrint('${_indent()}]');
      } else {
        logPrint('\n${response.data.toString()}');
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(header: 'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}', text: uri.toString());
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(header: 'Request ║ $method', text: uri.toString());
  }

  void _printLine([String pre = '', String suf = '╝']) => logPrint('$pre${'═' * maxWidth}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(pre);
      _printBlock(msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint((i >= 0 ? '' : '') + msg.substring(i * maxWidth, math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = kInitialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int initialTab = kInitialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var tabs = initialTab;
    final isRoot = tabs == kInitialTab;
    final initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'([\r\n])+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          logPrint('║${_indent(tabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          logPrint('║${_indent(tabs)} $key: {');
          _printPrettyMap(value, initialTab: tabs);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          logPrint('║${_indent(tabs)} $key: ${value.toString()}');
        } else {
          logPrint('║${_indent(tabs)} $key: [');
          _printList(value, tabs: tabs);
          logPrint('║${_indent(tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logPrint('║${_indent(tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
          }
        } else {
          logPrint('║${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(List list, {int tabs = kInitialTab}) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          logPrint('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(e, initialTab: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        logPrint('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  void _printUint8List(Uint8List list, {int tabs = kInitialTab}) {
    var chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize),
      );
    }
    for (var element in chunks) {
      logPrint('║${_indent(tabs)} ${element.join(", ")}');
    }
  }

  bool _canFlattenMap(Map map) {
    return map.values.where((dynamic val) => val is Map || val is List).isEmpty && map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    logPrint('╔ $header ');
    map.forEach((dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }
}
