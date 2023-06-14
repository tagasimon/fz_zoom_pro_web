import 'package:flutter/material.dart';

class FieldTileWidget extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  const FieldTileWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          Flexible(child: subtitle),
        ],
      ),
    );
  }
}
