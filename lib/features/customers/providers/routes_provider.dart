import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final routesRepoProvider = Provider<RoutesRepository>((ref) {
  return RoutesRepository();
});

final watchCompanyRoutesProvider = StreamProvider<List<RouteModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(routesRepoProvider)
      .watchAllCompanyRoutes(companyId: companyId);
});
