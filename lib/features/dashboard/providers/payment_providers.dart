import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final paymentsProvider = Provider<PaymentsRepository>((ref) {
  return PaymentsRepository(ref.watch(firestoreInstanceProvider));
});

final orderPayementsProvider = FutureProvider.family
    .autoDispose<List<PayementModel>, String>((ref, orderId) {
  final filter = ref.watch(sessionNotifierProvider);
  return ref.watch(paymentsProvider).nGetPayementEvidences(
      orderId: orderId, companyId: filter.loggedInUser!.companyId);
});
