import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/features/visits/providers/visits_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final sellOutOrdersProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(firestoreInstanceProvider));
});

final sellOutRepoProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(firestoreInstanceProvider));
});

final payementsProvider = Provider<PaymentsRepository>((ref) {
  return PaymentsRepository(ref.watch(firestoreInstanceProvider));
});

final dashboardProvider = FutureProvider.autoDispose<List<dynamic>>(
  (ref) {
    final filter = ref.watch(sessionNotifierProvider);
    if (filter.loggedInUser == null) return Future.value([]);

    return Future.wait([
      ref.watch(sellOutRepoProvider).nGetAllCompanyOrders(
          companyId: filter.loggedInUser!.companyId,
          startDate: filter.startDate,
          endDate: filter.endDate),
      ref.watch(visitAdherenceProvider).nGetAllCompanyVisits(
          companyId: filter.loggedInUser!.companyId,
          startDate: filter.startDate,
          endDate: filter.endDate),
      ref.watch(payementsProvider).getAllCompanyCollections(
          companyId: filter.loggedInUser!.companyId,
          startDate: filter.startDate,
          endDate: filter.endDate)
    ]);
  },
);
