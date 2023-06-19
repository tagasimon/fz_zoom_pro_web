import 'package:field_zoom_pro_web/core/presentation/widgets/animation_widget.dart';
import 'package:flutter/material.dart';

class NothingFoundAnimation extends StatelessWidget {
  final String title;
  final String url;
  const NothingFoundAnimation({
    super.key,
    this.title = "Nothing Found",
    this.url = "https://assets1.lottiefiles.com/packages/lf20_NeuXI2OPLG.json",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimationWidget(url: url),
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
