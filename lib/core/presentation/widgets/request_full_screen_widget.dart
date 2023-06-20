// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:flutter/material.dart';

class RequestFullScreenWidget extends StatelessWidget {
  const RequestFullScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // if full screen is enabled, exit full screen
        if (document.fullscreenElement != null) {
          document.exitFullscreen();
        } else {
          // else enter full screen
          document.documentElement!.requestFullscreen();
        }
      },
      icon: document.fullscreenElement == null
          ? const Icon(Icons.fullscreen)
          : const Icon(Icons.fullscreen_exit),
    );
  }
}
