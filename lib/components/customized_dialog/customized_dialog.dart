import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'env/params.dart';

/// 弹窗基类
abstract class CustomizedDialog extends Dialog {
  final CustomizedDialogParams params;

  /// 自定义对话框
  ///
  /// ***
  /// [CustomizedDialogParams]
  /// ***
  const CustomizedDialog({
    super.key,
    required this.params,
  }) : super(backgroundColor: Colors.transparent);

  /// 对话框背景板Decoration
  ///
  /// ***
  /// [CustomizedDialogParams]
  /// ***
  BoxDecoration get panelDecoration;

  /// 标题组件
  ///
  /// ***
  /// [CustomizedDialogParams]
  /// ***
  Widget? get titleWidget;

  /// 内容组件
  ///
  /// ***
  /// [CustomizedDialogParams]
  /// ***
  Widget get contentWidget;

  /// 按钮组件
  ///
  /// ***
  /// [CustomizedDialogParams]
  /// ***
  List<Widget> get buttonWidgets;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: IntrinsicWidth(
          child: Container(
            decoration: panelDecoration,
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.w),
                titleWidget ?? const SizedBox.shrink(),
                contentWidget,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: buttonWidgets,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
