import 'package:flutter/cupertino.dart';

/// `一次点击` 按钮
/// - 屏蔽连击
/// - onTap 有try catch
/// ***
/// [OnceButton]
/// ***
class OnceButton extends StatefulWidget {
  final Future<void> Function() onTap;
  final Future<void> Function()? onLongPress;
  final Widget? child;
  final bool enabled;

  const OnceButton({
    super.key,
    required this.onTap,
    this.onLongPress,
    this.child,
    this.enabled = true,
  });

  @override
  OnceButtonState createState() => OnceButtonState();
}

class OnceButtonState extends State<OnceButton> {
  ///是否可以点击
  bool _clickable = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        try {
          if (!widget.enabled) {
            return;
          }
          if (!_clickable) {
            return;
          }
          _clickable = false;

          if (widget.onLongPress != null) {
            await widget.onLongPress!();
          }

          _clickable = true;
        } catch (e) {
          _clickable = true;
        }
      },
      onTap: () async {
        try {
          if (!widget.enabled) {
            return;
          }
          if (!_clickable) {
            return;
          }
          _clickable = false;

          await widget.onTap();

          _clickable = true;
        } catch (e) {
          _clickable = true;
        }
      },
      child: widget.child,
    );
  }
}
