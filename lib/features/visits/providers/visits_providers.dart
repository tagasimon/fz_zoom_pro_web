import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final visitAdherenceProvider = Provider<VisitRepository>((ref) {
  return VisitRepository(ref.watch(firestoreInstanceProvider));
});

final companyVisitsProvider =
    FutureProvider.autoDispose<List<VisitModel>>((ref) async {
  final filter = ref.watch(sessionNotifierProvider);
  if (filter.loggedInUser == null) return Future.value([]);
  return ref.watch(visitAdherenceProvider).nGetAllCompanyVisits(
      companyId: filter.loggedInUser!.companyId,
      startDate: filter.startDate,
      endDate: filter.endDate);
});

final customerLastVisitProvider = FutureProvider.family
    .autoDispose<VisitModel?, String>((ref, customerId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(visitAdherenceProvider)
      .getCustomersLastVisit(companyId: companyId, customerId: customerId);
});
