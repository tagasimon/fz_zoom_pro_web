import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationWidget extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;

  const AnimationWidget(
      {super.key, required this.url, this.height = 200, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.network(
        url,
        height: height,
        width: height,
        errorBuilder: (_, __, l) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
