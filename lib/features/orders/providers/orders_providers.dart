import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(firestoreInstanceProvider));
});

final customerLastOrderProvider = FutureProvider.family
    .autoDispose<OrderModel?, String>((ref, customerId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(ordersRepositoryProvider)
      .getLastOrder(companyId: companyId, customerId: customerId);
});

final getCustomerLastOrderProvider =
    FutureProvider.family<OrderModel?, String>((ref, customerId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(ordersRepositoryProvider)
      .getLastOrder(companyId: companyId, customerId: customerId);
});
