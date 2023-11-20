import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Avatar extends StatefulWidget {
  final String uri;
  final double width;
  final double height;
  final Decoration decoration;
  final bool withFrame;
  final String? defaultAvatar;

  const Avatar({
    super.key,
    required this.uri,
    required this.width,
    required this.height,
    this.decoration = const BoxDecoration(shape: BoxShape.circle),
    this.withFrame = true,
    this.defaultAvatar,
  });

  @override
  AvatarState createState() => AvatarState();
}

class AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          widget.uri.isNotEmpty
              ? Image(
                  image: NetworkImage(widget.uri),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image(
                      image: AssetImage(
                          widget.defaultAvatar ?? "assets/common/avatar.png"),
                    );
                  },
                )
              : Image(
                  image: AssetImage(
                      widget.defaultAvatar ?? "assets/common/avatar.png"),
                ),
          widget.withFrame
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((widget.width / 2).w),
                    border: Border.all(color: Colors.white, width: 2.w),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
