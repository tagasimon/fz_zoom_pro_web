import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_cartegory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCartegoryFilterWidget extends ConsumerWidget {
  const ProductCartegoryFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCartegories = ref.watch(watchProductsCartegoriesProvider);
    return productCartegories.when(
      data: (regionsList) {
        return Row(
          children: [
            const Text('CARTEGORY:'),
            const SizedBox(width: 8),
            DropdownButton<String?>(
                hint: const Text('Select Cartegory'),
                value: ref.watch(productFilterNotifierProvider).cartegory,
                onChanged: (String? value) {
                  if (value == null) return;
                  ref
                      .read(productFilterNotifierProvider.notifier)
                      .updateCartegory(cartegoryId: value);
                },
                items: regionsList
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.id,
                        child: Text(e.name),
                      ),
                    )
                    .toList()),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
