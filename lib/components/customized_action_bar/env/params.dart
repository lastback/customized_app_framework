import 'package:flutter/material.dart';

class CustomizedActionBarItemParams {
  final String title;

  final Widget? titleWidget;

  Future<void> Function(BuildContext context) onTap;

  ///  action bar item 配置参数
  ///
  /// `action bar`
  ///
  /// ***
  /// [CustomizedActionBarItemParams]
  /// ***
  CustomizedActionBarItemParams({
    required this.title,
    this.titleWidget,
    required this.onTap,
  });
}

class CustomizedActionBarParams {
  final List<CustomizedActionBarItemParams> items;

  ///  action bar配置参数
  ///
  /// `action bar`
  ///
  /// ***
  /// [CustomizedActionBarParams]
  /// ***
  CustomizedActionBarParams({
    required this.items,
  });
}
