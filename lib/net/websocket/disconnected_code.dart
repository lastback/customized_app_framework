/// https://pub-web.flutter-io.cn/documentation/web_socket_channel/latest/web_socket_channel.status/web_socket_channel.status-library.html
class DisconnectedCode {
  /// `code = 1000`
  /// - `The purpose for which the connection was established has been fulfilled.`
  static const int kNormalClosure = 1000;

  /// `code = 1001`
  /// - `An endpoint is "going away", such as a server going down or a browser having navigated away from a page.`
  static const int kGoingAway = 1001;

  /// `code = 1002`
  /// - `An endpoint is terminating the connection due to a protocol error.`
  static const int kProtocolError = 1002;

  /// `code = 1003`
  /// - `An endpoint is terminating the connection because it has received a type of data it cannot accept.`
  static const int kUnsupportedData = 1003;

  /// `code = 1005`
  /// - `No status code was present.`
  static const int kNoStatusReceived = 1005;

  /// `code = 1006`
  /// - `The connection was closed abnormally.`
  static const int kAbnormalClosure = 1006;

  /// `code = 1007`
  /// - `An endpoint is terminating the connection because it has received data within a message that was not consistent with the type of the message.`
  static const int kInvalidFramePayloadData = 1007;

  /// `code = 1008`
  /// - `An endpoint is terminating the connection because it has received a message that violates its policy.`
  static const int kPolicyViolation = 1008;

  /// `code = 1009`
  /// - `An endpoint is terminating the connection because it has received a message that is too big for it to process.`
  static const int kMessageTooBig = 1009;

  /// `code = 1010`
  /// - `The client is terminating the connection because it expected the server to negotiate one or more extensions, but the server didn't return them in the response message of the WebSocket handshake.`
  static const int kMissingMandatoryExtension = 1010;

  /// `code = 1011`
  /// - `The server is terminating the connection because it encountered an unexpected condition that prevented it from fulfilling the request.`
  static const int kInternalServerError = 1011;

  /// `code = 1015`
  /// - `The connection was closed due to a failure to perform a TLS handshake.`
  static const int kTlsHandshakeFailed = 1015;
}
