import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveProductWidget extends ConsumerWidget {
  final Function() onCopy;
  final Function() onDelete;
  const ActiveProductWidget(
      {super.key, required this.onCopy, required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsControllerProvider);
    return Row(
      children: [
        TableActionWidget(
          title: "COPY",
          child: IconButton(
              onPressed: state.isLoading ? null : onCopy,
              icon: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(
                      Icons.copy,
                      color: Colors.tealAccent,
                    )),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "DELETE",
          child: IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}
