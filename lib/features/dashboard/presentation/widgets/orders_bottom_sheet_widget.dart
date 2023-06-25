import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class OrdersBottomSheetWidget extends ConsumerWidget {
  final List<OrderModel> orders;
  const OrdersBottomSheetWidget({super.key, required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    if (scrollController.hasClients) {
      scrollController.jumpTo(50.0);
    }
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: const Focus(
        autofocus: true,
        child: Column(
          children: [
            Row(
              children: [Text("data")],
            ),
            Row(
              children: [Text("data")],
            )
          ],
        ),
      ),
    );
  }
}
