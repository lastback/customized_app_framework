import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  final String uri;
  final double width;
  final double height;
  final BoxDecoration decoration;
  final BoxDecoration? frameDecoration;
  final String? defaultAvatar;

  const Avatar({
    super.key,
    required this.uri,
    required this.width,
    required this.height,
    this.decoration = const BoxDecoration(shape: BoxShape.circle),
    this.frameDecoration,
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
                  fit: BoxFit.cover,
                  image: AssetImage(
                      widget.defaultAvatar ?? "assets/common/avatar.png"),
                ),
          widget.frameDecoration != null
              ? Container(
                  decoration: widget.frameDecoration,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
