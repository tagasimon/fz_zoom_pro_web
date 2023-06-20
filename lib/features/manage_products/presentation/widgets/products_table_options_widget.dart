import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/screens/add_product_cartegory_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/screens/add_product_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/screens/add_sub_cartegory_cartegory_screen.dart';
import 'package:flutter/material.dart';
import 'package:fz_hooks/fz_hooks.dart';

class ProductsTableOptionsWidget extends StatelessWidget {
  const ProductsTableOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TableActionWidget(
          title: "Product",
          child: IconButton(
            onPressed: () =>
                context.push(const AddProductScreen(), fullscreenDialog: true),
            icon: const Icon(Icons.add_box_outlined),
          ),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "Sub Cart",
          child: IconButton(
            onPressed: () => context.push(const AddSubCartegoryScreen(),
                fullscreenDialog: true),
            icon: const Icon(Icons.note_add_outlined),
          ),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "Cart",
          child: IconButton(
            onPressed: () => context.push(const AddProductCartegoryScreen(),
                fullscreenDialog: true),
            icon: const Icon(Icons.note_add_sharp),
          ),
        ),
      ],
    );
  }
}
