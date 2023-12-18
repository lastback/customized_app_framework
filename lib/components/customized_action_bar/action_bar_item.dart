import 'package:customized_app_framework/components/buttons/once_button.dart';
import 'package:flutter/material.dart';
import 'env/params.dart';

abstract class CustomizedActionBarItem extends StatelessWidget {
  final CustomizedActionBarItemParams params;

  ///  自定义底部弹出action bar item
  ///
  /// `action bar`
  ///
  /// ***
  /// [CustomizedActionBarItem]
  /// ***
  const CustomizedActionBarItem({super.key, required this.params});

  BoxConstraints get constraints;

  BoxDecoration get decoration;

  TextStyle get textStyle;

  @override
  Widget build(BuildContext context) {
    return OnceButton(
      onTap: () async {
        params.onTap(context);
      },
      child: Container(
        constraints: constraints,
        decoration: decoration,
        alignment: Alignment.center,
        child: params.titleWidget ?? Text(params.title, style: textStyle),
      ),
    );
  }
}
