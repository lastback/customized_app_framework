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
  open({
    required Uri uri,
    Iterable<String>? protocols,
    Duration? pingInterval,
    Backoff? backoff,
    Duration? timeout,
    String? binaryType,
  }) async {
    logger.i('uri = $uri');
    if (client == null) {
      client = WebSocket(
        uri,
        pingInterval: pingInterval,
        backoff: backoff,
        timeout: timeout,
        binaryType: binaryType,
      );

      // Listen for changes in the connection state.
      client?.connection.listen(onConnectionState);

      // Listen for incoming messages.
      client?.messages.listen(onIncomings);
    } else {
      throw 'client = $client connection state = ${client?.connection.state}';
    }
  }

  @protected
  close({int? code, String? reason}) async {
    client?.close(code, reason);
  }

  /// 连接状态变化
  @protected
  onConnectionState(ConnectionState state) async {
    logger.i('connection state = $state');

    if (state is Connected) {
    } else if (state is Disconnected) {
      client = null;
      logger.i('disconnect code = ${state.code}');
    } else if (state is Reconnecting) {}
  }

  @protected
  onIncomings(message) async {
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
