import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final regionsRepoProvider = Provider<RegionsRepository>((ref) {
  final firestore = ref.watch(firestoreInstanceProvider);
  return RegionsRepository(firestore);
});

final companyRegionsProvider = StreamProvider<List<RegionModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(regionsRepoProvider)
      .getAllCompanyRegions(companyId: companyId);
});
