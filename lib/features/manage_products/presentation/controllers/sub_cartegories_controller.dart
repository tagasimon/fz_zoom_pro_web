import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class SubCartegoriesController extends StateNotifier<AsyncValue> {
  SubCartegoriesController() : super(const AsyncValue.data(null));

  Future<bool> addNewSubProductCategory({
    required SubCartegoryModel subCartegory,
  }) async {
    state = const AsyncValue.loading();
    final subCartegoryRepo = SubCartegoryRepository();
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
    final subCartegoryRepo = SubCartegoryRepository();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return subCartegoryRepo.updateSubCartegory(
          companyId: companyId, id: id, subCartegory: subCartegoryModel);
    });

    return state.hasError ? false : true;
  }
}
