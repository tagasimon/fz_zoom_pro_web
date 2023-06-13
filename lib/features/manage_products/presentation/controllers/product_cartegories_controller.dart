import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class ProductCartegoriesController extends StateNotifier<AsyncValue> {
  ProductCartegoriesController() : super(const AsyncValue.data(null));

  Future<bool> addNewProductCategory(
      {required ProductCartegoryModel productCartegoryModel}) async {
    final productCartRepo = CartegoryRepository();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return productCartRepo.addNewProductCategory(
          productCartegoryModel: productCartegoryModel);
    });
    return state.hasError ? false : true;
  }

  // update product cartegory status
  Future<bool> updateProductCartegoryStatus({
    required String companyId,
    required String id,
    required bool status,
  }) async {
    final productCartRepo = CartegoryRepository();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return productCartRepo.updateProductCartegoryStatus(
          companyId: companyId, id: id, status: status);
    });

    return state.hasError ? false : true;
  }

  //update product cartegory name
  Future<bool> updateProductCartegoryName({
    required String companyId,
    required String id,
    required String name,
  }) async {
    final productCartRepo = CartegoryRepository();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return productCartRepo.updateProductCartegoryName(
          companyId: companyId, id: id, name: name);
    });

    return state.hasError ? false : true;
  }

  Future<bool> updateProductCartegory({
    required String companyId,
    required String id,
    required ProductCartegoryModel productCartegoryModel,
  }) async {
    final productCartRepo = CartegoryRepository();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return productCartRepo.updateCartegory(
          companyId: companyId,
          id: id,
          productCartegoryModel: productCartegoryModel);
    });

    return state.hasError ? false : true;
  }
}
