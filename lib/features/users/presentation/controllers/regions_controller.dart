import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final regionsControllerProvider =
    StateNotifierProvider.autoDispose<RegionsController, AsyncValue>((ref) {
  final firestore = ref.watch(firestoreInstanceProvider);
  return RegionsController(firestore);
});

class RegionsController extends StateNotifier<AsyncValue> {
  final FirebaseFirestore firestore;
  RegionsController(this.firestore) : super(const AsyncValue.data(null));

  Future<bool> addNewRegion({
    required RegionModel region,
  }) async {
    try {
      final regionRepo = RegionsRepository(firestore);
      state = const AsyncValue.loading();
      final bool isRegionExist =
          await regionRepo.checkIfRegionExists(region: region);
      if (isRegionExist) {
        state = AsyncError("${region.name} already exists", StackTrace.current);
        return false;
      }
      await regionRepo.addNewRegion(region: region);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }

  Future<bool> editRegion({
    required String regionId,
    required RegionModel region,
  }) async {
    try {
      final regionRepo = RegionsRepository(firestore);
      state = const AsyncValue.loading();
      await regionRepo.updateRegion(region: region);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }
}
