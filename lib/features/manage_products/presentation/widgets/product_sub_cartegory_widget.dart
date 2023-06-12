import 'package:field_zoom_pro_web/features/manage_products/providers/sub_cartegory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSubCartegoryWidget extends ConsumerWidget {
  final String id;
  const ProductSubCartegoryWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subCartegoryProv = ref.watch(subCartegoryByIdProvider(id));
    return subCartegoryProv.when(
      data: (subCart) => Text(subCart.name),
      error: (error, stackTrace) => const Text("Error"),
      loading: () => const Text("..."),
    );
  }
}
