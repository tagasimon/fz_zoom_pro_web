import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final regionsRepoProvider = Provider<RegionsRepository>((ref) {
  return RegionsRepository(ref.watch(firestoreInstanceProvider));
});

final companyRegionsProvider = StreamProvider<List<RegionModel>>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(regionsRepoProvider)
      .getAllCompanyRegions(companyId: companyId);
});
