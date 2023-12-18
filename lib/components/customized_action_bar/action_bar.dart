import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_slots/app/themes.dart';

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

  List<CustomizedActionBarItem> get items;

  CustomizedActionBarItem get cancel;

  @override
  Widget build(BuildContext context) {
    final ThemeDataExt theme = Theme.of(context).extension<ThemeDataExt>()!;
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.p004ContentBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.w),
                  topRight: Radius.circular(12.w),
                ),
              ),
              child: Column(children: items),
            ),
            SizedBox(height: 10.w),
            Container(
              color: theme.p004ContentBg,
              child: SafeArea(top: false, child: cancel),
            )
          ],
        ),
      ),
    );
  }
}
