import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final routesRepoProvider = Provider<RoutesRepository>((ref) {
  return RoutesRepository(ref.watch(firestoreInstanceProvider));
});

final watchCompanyRoutesProvider = StreamProvider<List<RouteModel>>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(routesRepoProvider)
      .watchAllCompanyRoutes(companyId: companyId);
});
