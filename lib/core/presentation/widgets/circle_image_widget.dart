import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImageWidget extends StatelessWidget {
  final String url;
  final Function()? onTap;
  const CircleImageWidget({super.key, required this.url, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ),
      ],
    );
  }
}
