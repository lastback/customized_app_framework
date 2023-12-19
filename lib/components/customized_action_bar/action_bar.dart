import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'action_bar_item.dart';
import 'env/params.dart';

abstract class CustomizedActionBar extends Dialog {
  final CustomizedActionBarParams params;

  ///  自定义底部弹出action bar
  ///
  /// `action bar`
  ///
  /// ***
  /// [CustomizedActionBar]
  /// ***
  const CustomizedActionBar({super.key, required this.params});

  BoxDecoration get panelDecoration;

  Color get panelBgColor;

  List<CustomizedActionBarItem> get items;

  CustomizedActionBarItem get cancel;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: panelDecoration,
              child: Column(children: items),
            ),
            SizedBox(height: 10.w),
            Container(
              color: panelBgColor,
              child: SafeArea(top: false, child: cancel),
            )
          ],
        ),
      ),
    );
  }
}
