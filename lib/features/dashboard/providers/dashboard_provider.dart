import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/features/dashboard/providers/firebase_instance_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final sellOutOrdersProvider = Provider<OrdersRepository>((ref) {
  final firestore = ref.watch(firestoreInstaceProvider);
  return OrdersRepository(firestore);
});

final visitAdherenceProvider = Provider<VisitRepository>((ref) {
  final firestore = ref.watch(firestoreInstaceProvider);
  return VisitRepository(firestore);
});

final sellOutRepoProvider = Provider<OrdersRepository>((ref) {
  final firestore = ref.watch(firestoreInstaceProvider);
  return OrdersRepository(firestore);
});

final dashboardProvider = FutureProvider.autoDispose<List<dynamic>>((ref) {
  final filter = ref.watch(filterNotifierProvider);
  if (filter.loggedInuser == null) return Future.value([]);
  return Future.wait([
    ref.watch(sellOutRepoProvider).nGetAllCompanyOrders(
        companyId: filter.loggedInuser!.companyId,
        startDate: filter.startDate!,
        endDate: filter.endDate!),
    ref.watch(visitAdherenceProvider).nGetAllCompanyVisits(
        companyId: filter.loggedInuser!.companyId,
        startDate: filter.startDate!,
        endDate: filter.endDate!),
  ]);
});
