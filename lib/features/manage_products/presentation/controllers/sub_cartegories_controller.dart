import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class SubCartegoriesController extends StateNotifier<AsyncValue> {
  final FirebaseFirestore firestore;
  SubCartegoriesController(this.firestore) : super(const AsyncValue.data(null));

  Future<bool> addNewSubProductCategory({
    required SubCartegoryModel subCartegory,
  }) async {
    state = const AsyncValue.loading();
    final subCartegoryRepo = SubCartegoryRepository(firestore);
    state = await AsyncValue.guard(() {
      return subCartegoryRepo.addNewSubProductCategory(
          subCartegory: subCartegory);
    });
    return state.hasError ? false : true;
  }

  Future<bool> updateSubProductCartegory({
    required String companyId,
    required String id,
    required SubCartegoryModel subCartegoryModel,
  }) async {
    final subCartegoryRepo = SubCartegoryRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return subCartegoryRepo.updateSubCartegory(
          companyId: companyId, id: id, subCartegory: subCartegoryModel);
    });

    return state.hasError ? false : true;
  }

  Future<bool> deleteSubCartegoryById(
      {required String companyId, required String subCartid}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final productCartRepo = SubCartegoryRepository(firestore);
      return productCartRepo.deleteSubCartegoryId(
          companyId: companyId, subCartId: subCartid);
    });
    return state.hasError ? false : true;
  }
}
