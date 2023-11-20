import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Toast component
/// - ToastUtils.toast(text: "你好呀");
/// ***
/// [ToastUtils]
/// ***
class ToastUtils {
  static void toast({required String text}) async {
    //获取OverlayState
    OverlayState overlayState =
        GlobalKey<NavigatorState>().currentState!.overlay!;
    //创建OverlayEntry
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        bottom: 50,
        left: 1,
        right: 1,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5.w)),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: Text(
                text,
                softWrap: true,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    //显示到屏幕上。
    overlayState.insert(overlayEntry);
    //等待2秒
    await Future.delayed(const Duration(seconds: 5));
    //移除
    overlayEntry.remove();
  }
}
