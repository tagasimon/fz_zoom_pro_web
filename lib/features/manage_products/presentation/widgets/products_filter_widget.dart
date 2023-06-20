import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/product_cartegory_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/sub_cartegory_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsFilterWidget extends ConsumerWidget {
  const ProductsFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<int> dropDownItems =
        List.generate(20, (index) => (index + 1) * 2);
    final itemsPerPage = ref.watch(productFilterNotifierProvider).itemCount;
    final filteredCartegory =
        ref.watch(productFilterNotifierProvider).cartegory;
    final filteredSubCartegory =
        ref.watch(productFilterNotifierProvider).subCartegory;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          hint: Text('$itemsPerPage items per page'),
          items: dropDownItems
              .map((e) =>
                  DropdownMenuItem<int>(value: e, child: Text(e.toString())))
              .toList(),
          onChanged: (val) {
            if (val == null) return;
            ref
                .read(productFilterNotifierProvider.notifier)
                .updateItemCount(itemCount: val);
          },
        ),
        const VerticalDivider(),
        const ProductCartegoryFilterWidget(),
        const VerticalDivider(),
        const SubProductCartegoryFilterWidget(),
        const VerticalDivider(),
        if (filteredSubCartegory != null || filteredCartegory != null)
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              ref.read(productFilterNotifierProvider.notifier).resetFilter();
            },
            label: const Text('Reset'),
            icon: const Icon(Icons.refresh),
          ),
      ],
    );
  }
}
