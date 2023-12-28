import 'package:customized_app_framework/components/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

abstract class CustomizedMarqueeViewModel extends FutureViewModel {
  final TickerProvider vsync;

  /// CustomizedMarquee vm
  ///
  /// ***
  /// [CustomizedMarqueeViewModel]
  /// ***
  CustomizedMarqueeViewModel({required this.vsync});

  String text = "";

  late AnimationController animationController = AnimationController(
      vsync: vsync, duration: const Duration(milliseconds: 0));

  late Animation animationSequence = TweenSequence([
    TweenSequenceItem(
      tween: Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)),
      weight: 1,
    ),
  ]).animate(animationController);

  /// 计算
  void caculate(BuildContext context, RenderAfterLayout ral) async {
    final width = ral.size.width;

    if (width == 0) {
      return;
    }

    const upDuration = 2000; //ms

    const stay01Duration = 2000; //ms

    const pixelDuration = 50; //ms

    const stay02Duration = 2000; //ms

    int duration =
        (upDuration + stay01Duration + width * pixelDuration + stay02Duration)
            .toInt();

    final upWeight = upDuration / duration;

    final stay01Weight = stay01Duration / duration;

    final stay02Weight = stay02Duration / duration;

    final rollWeight = 1 - (upWeight + stay01Weight + stay02Weight);

    animationController.duration = Duration(milliseconds: duration);

    animationSequence = TweenSequence([
      // up: 2000
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)),
        weight: upWeight,
      ),
      // stay: 2000
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0)),
        weight: stay01Weight,
      ),
      // roll:
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0)),
        weight: rollWeight,
      ),
      // stay: 2000
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(-1, 0)),
        weight: stay02Weight,
      ),
    ]).animate(animationController);

    await animationController.forward();
    animationController.reset();

    await loadNext();

    rebuildUi();
  }

  Future<void> loadNext();
}
