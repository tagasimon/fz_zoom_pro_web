import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final routesRepoProvider = Provider<RoutesRepository>((ref) {
  return RoutesRepository(ref.watch(firestoreInstanceProvider));
});

final routeByIdProvider =
    FutureProvider.family<RouteModel, String>((ref, routeId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .read(routesRepoProvider)
      .getRouteByCompanyIdAndRouteId(companyId: companyId, routeId: routeId);
});

// list of route id provider

final routesByIdProvider =
    FutureProvider.family<List<ChartDataModel>, List<ChartDataModel>>(
        (ref, data) async {
  List<ChartDataModel> routesChartData = [];
  for (var route in data) {
    final routeData = await ref.read(routeByIdProvider(route.title).future);
    routesChartData.add(ChartDataModel(routeData.name, route.value));
  }
  return routesChartData;
});
