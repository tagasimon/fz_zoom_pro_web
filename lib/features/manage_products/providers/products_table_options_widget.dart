import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:flutter/material.dart';

class ProductsTableOptionsWidget extends StatelessWidget {
  const ProductsTableOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TableActionWidget(
          title: "PRODUCT",
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_box_outlined),
          ),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "SUB CARTEGORY",
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.note_add_outlined),
          ),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "CARTEGORY",
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.note_add_sharp),
          ),
        ),
      ],
    );
  }
}
