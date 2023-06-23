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
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
          onPressed: state.isLoading ? null : onCopy,
          icon: const Icon(Icons.copy),
          label: state.isLoading
              ? const CircularProgressIndicator()
              : const Text("Copy"),
        ),
        const VerticalDivider(),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
          label: const Text("Delete"),
        ),
        const VerticalDivider(),
      ],
    );
  }
}
