import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final routesRepoProvider = Provider<RoutesRepository>((ref) {
  return RoutesRepository();
});

final routeByIdProvider =
    FutureProvider.family<RouteModel, String>((ref, routeId) async {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .read(routesRepoProvider)
      .getRouteByCompanyIdAndRouteId(companyId: companyId, routeId: routeId);
});
