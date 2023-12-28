import 'package:customized_app_framework/components/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'marquee_viewmodel.dart';

abstract class CustomizedMarqueeState<W extends StatefulWidget,
        VM extends CustomizedMarqueeViewModel> extends State<W>
    with SingleTickerProviderStateMixin {
  Widget Function(VM viewModel) get widgetBuilder;

  VM Function() get viewModelBuilder;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: viewModelBuilder,
      builder: (context, viewModel, child) {
        return Container(
          decoration: const BoxDecoration(),
          clipBehavior: Clip.hardEdge,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: AnimatedBuilder(
              animation: viewModel.animationSequence,
              builder: (context, child) {
                return FractionalTranslation(
                  translation: viewModel.animationSequence.value,
                  child: AfterLayout(
                    callback: (RenderAfterLayout ral) {
                      viewModel.caculate(context, ral);
                    },
                    child: widgetBuilder(viewModel),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
