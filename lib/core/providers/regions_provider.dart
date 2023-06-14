import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final regionsProvider =
    Provider<RegionsRepository>((ref) => RegionsRepository());

final allRegionProvider = FutureProvider<List<RegionModel>>((ref) async {
  final user = ref.watch(filterNotifierProvider).loggedInuser!;
  return ref
      .watch(regionsProvider)
      .getAllCompanyRegionsFuture(companyId: user.companyId);
});

final getRegionByCompanyIdProvider =
    FutureProvider.family<RegionModel, String>((ref, regionId) async {
  final user = ref.watch(filterNotifierProvider).loggedInuser!;
  return ref.watch(regionsProvider).getRegionByCompanyIdAndRegionId(
      companyId: user.companyId, regionId: regionId);
});

final companyRegionsProv = StreamProvider.autoDispose<List<RegionModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref.watch(regionsProvider).getAllCompanyRegions(companyId: companyId);
});

final getRegionByCompanyIdAndRouteIdProvider =
    FutureProvider.family.autoDispose<RegionModel, String>((ref, id) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(regionsProvider)
      .getRegionByCompanyIdAndRegionId(companyId: companyId, regionId: id);
});
