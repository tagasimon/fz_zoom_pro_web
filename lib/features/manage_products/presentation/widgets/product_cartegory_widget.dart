import 'package:field_zoom_pro_web/features/manage_products/providers/product_cartegory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCartegoryWidget extends ConsumerWidget {
  final String cartegoryId;
  const ProductCartegoryWidget({super.key, required this.cartegoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartegoryProv = ref.watch(productCartegoryByIdProvider(cartegoryId));
    return cartegoryProv.when(
      data: (subCart) => Text(subCart.name),
      error: (error, stackTrace) => const Text("Error"),
      loading: () => const Text("..."),
    );
  }
}
