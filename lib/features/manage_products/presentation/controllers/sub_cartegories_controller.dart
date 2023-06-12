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
    // if (!mounted) return false;
  }
}
