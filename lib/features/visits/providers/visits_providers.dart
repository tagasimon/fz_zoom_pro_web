import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final visitRepoProvider = Provider<VisitRepository>((ref) {
  return VisitRepository(ref.watch(firestoreInstanceProvider));
});

final customerLastVisitProvider = FutureProvider.family
    .autoDispose<VisitModel?, String>((ref, customerId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(visitRepoProvider)
      .getCustomersLastVisit(companyId: companyId, customerId: customerId);
});
