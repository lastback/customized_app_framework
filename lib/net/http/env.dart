/// 网络请求method
/// ***
/// [HttpMethod]
/// ***
class HttpMethod {
  static const String kGet = 'GET';

  static const String kPost = 'POST';
}

/// 网络请求状态
/// ***
/// [EnumHttpState]
/// ***
enum EnumHttpState {
  /// 空闲
  idle,

  /// 忙碌
  busy,

  /// 超时
  timeout,

  /// 失败
  fail,

  /// 成功
  success,
}
