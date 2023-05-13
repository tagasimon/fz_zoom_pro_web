import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final regionsProvider =
    Provider<RegionsRepository>((ref) => RegionsRepository());

final allRegionProvider = FutureProvider<List<RegionModel>>((ref) async {
  final user = ref.watch(filterNotifierProvider).user!;
  return ref
      .watch(regionsProvider)
      .getAllCompanyRegionsFuture(companyId: user.companyId);
});

final getRegionByCompanyIdProvider =
    FutureProvider.family<RegionModel, String>((ref, regionId) async {
  final user = ref.watch(filterNotifierProvider).user!;
  return ref.watch(regionsProvider).getRegionByCompanyIdAndRegionId(
      companyId: user.companyId, regionId: regionId);
});
