import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final regionsProvider = Provider<RegionsRepository>((ref) {
  return RegionsRepository(ref.watch(firestoreInstanceProvider));
});

final allRegionProvider = FutureProvider<List<RegionModel>>((ref) async {
  final user = ref.watch(sessionNotifierProvider).loggedInuser!;
  return ref
      .watch(regionsProvider)
      .getAllCompanyRegionsFuture(companyId: user.companyId);
});

final getRegionByCompanyIdProvider =
    FutureProvider.family<RegionModel, String>((ref, regionId) async {
  final user = ref.watch(sessionNotifierProvider).loggedInuser!;
  return ref.watch(regionsProvider).getRegionByCompanyIdAndRegionId(
      companyId: user.companyId, regionId: regionId);
});

final companyRegionsProv = StreamProvider.autoDispose<List<RegionModel>>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInuser!.companyId;
  return ref.watch(regionsProvider).getAllCompanyRegions(companyId: companyId);
});

final getRegionByCompanyIdAndRouteIdProvider =
    FutureProvider.family.autoDispose<RegionModel, String>((ref, id) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(regionsProvider)
      .getRegionByCompanyIdAndRegionId(companyId: companyId, regionId: id);
});
