import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/features/authentication/providers/user_provider.dart';
import 'package:field_zoom_pro_web/features/customers/providers/customer_provider.dart';
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

final companyVisitsAndCustomersProvider =
    FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final filter = ref.watch(sessionNotifierProvider);
  if (filter.loggedInUser == null) return Future.value([]);
  return Future.wait([
    ref.watch(visitAdherenceProvider).nGetAllCompanyVisits(
        companyId: filter.loggedInUser!.companyId,
        startDate: filter.startDate,
        endDate: filter.endDate),
    ref
        .watch(customersRepoProvider)
        .getAllCompanyCustomers(companyId: filter.loggedInUser!.companyId),
    ref
        .watch(userRepoProvider)
        .getAllCompanyUsersFuture(companyId: filter.loggedInUser!.companyId)
  ]);
});

final customerLastVisitProvider = FutureProvider.family
    .autoDispose<VisitModel?, String>((ref, customerId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(visitAdherenceProvider)
      .getCustomersLastVisit(companyId: companyId, customerId: customerId);
});
