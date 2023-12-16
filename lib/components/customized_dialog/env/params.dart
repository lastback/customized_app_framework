class CustomizedDialogButton {
  /// 按钮序号
  int index;

  /// 按钮文本
  String text;

  /// 按钮点击
  Future<void> Function() onTap;

  /// 自定义对话框按钮配置
  ///
  /// ***
  /// [CustomizedDialogParams]
  /// ***
  CustomizedDialogButton({
    required this.index,
    required this.text,
    required this.onTap,
  });
}

class CustomizedDialogParams {
  /// 标题
  String? title;

  /// 内容
  String content;

  /// 按钮
  List<CustomizedDialogButton> buttons;

  /// 自定义对话框配置
  ///
  /// ***
  /// [CustomizedDialogParams]
  /// ***
  CustomizedDialogParams({
    this.title,
    required this.content,
    required this.buttons,
  });
}
