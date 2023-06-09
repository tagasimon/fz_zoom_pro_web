import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final regionsControllerProvider =
    StateNotifierProvider.autoDispose<RegionsController, AsyncValue>((ref) {
  return RegionsController();
});

class RegionsController extends StateNotifier<AsyncValue> {
  final regionsDB = 'FZ_REGIONS';
  RegionsController() : super(const AsyncValue.data(null));

  Future<bool> addNewRegion({required RegionModel regionModel}) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      await FirebaseFirestore.instance
          .collection(regionsDB)
          .add(regionModel.toMap());
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }

  Future<bool> editRegion({
    required String regionId,
    required RegionModel newInfo,
  }) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      final ref = FirebaseFirestore.instance
          .collection(regionsDB)
          .where("id", isEqualTo: regionId)
          .get();
      await ref.then((doc) => doc.docs.first.reference.update(newInfo.toMap()));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }
}
