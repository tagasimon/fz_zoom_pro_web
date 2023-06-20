import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemPerPageWidget extends ConsumerWidget {
  const ItemPerPageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<int> dropDownItems =
        List.generate(20, (index) => (index + 1) * 2);
    final itemsPerPage = ref.watch(productFilterNotifierProvider).itemCount;
    return DropdownButton<int>(
      hint: Text('$itemsPerPage items per page'),
      items: dropDownItems
          .map(
              (e) => DropdownMenuItem<int>(value: e, child: Text(e.toString())))
          .toList(),
      onChanged: (val) {
        if (val == null) return;
        ref
            .read(productFilterNotifierProvider.notifier)
            .updateItemCount(itemCount: val);
      },
    );
  }
}
