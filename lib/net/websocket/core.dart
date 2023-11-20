import '../../log/customized_log.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_client/web_socket_client.dart';

abstract class SocketCore {
  /// `SocketCore`
  /// ***
  /// [SocketCore]
  /// ***
  SocketCore();

  String get logTag => '';

  @protected
  WebSocket? client;

  @protected
  late final logger = CustomizedLogger(printTag: logTag);

  @protected
  connect({
    required Uri uri,
    Iterable<String>? protocols,
    Duration? pingInterval,
    Backoff? backoff,
    Duration? timeout,
    String? binaryType,
  }) async {
    logger.i('uri = $uri');
    if (client == null) {
      client = WebSocket(uri);

      // Listen for changes in the connection state.
      client?.connection.listen(onConnection);

      // Listen for incoming messages.
      client?.messages.listen(onMessage);
    } else {
      throw 'client = $client connection state = ${client?.connection.state}';
    }
  }

  @protected
  disconnect({int? code, String? reason}) async {
    client?.close(code, reason);
  }

  @protected
  onConnection(ConnectionState state) async {
    logger.i('connection state = $state');
    if (state is Connected) {
    } else if (state is Disconnected) {
      client = null;
      logger.i('disconnect code = ${state.code}');
    }
  }

  @protected
  onMessage(message) async {
    logger.i('incoming = $message');
  }

  /// 发送消息
  /// ***
  /// [SocketCore]
  /// ***
  send(message) {
    if (client?.connection.state is Connected) {
      client?.send(message);
    } else {
      throw 'connection state = ${client?.connection.state}';
    }
  }
}
