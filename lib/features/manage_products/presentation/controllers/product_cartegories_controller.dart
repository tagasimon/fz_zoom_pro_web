import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class ProductCartegoriesController extends StateNotifier<AsyncValue> {
  final FirebaseFirestore firestore;
  ProductCartegoriesController(this.firestore)
      : super(const AsyncValue.data(null));

  Future<bool> addNewProductCategory({
    required ProductCartegoryModel productCartegoryModel,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final productCartRepo = CartegoryRepository(firestore);
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final productCartRepo = CartegoryRepository(firestore);
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
    final productCartRepo = CartegoryRepository(firestore);
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
    final productCartRepo = CartegoryRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return productCartRepo.updateCartegory(
          companyId: companyId,
          id: id,
          productCartegoryModel: productCartegoryModel);
    });

    return state.hasError ? false : true;
  }

  Future<bool> deleteCartegoryById(
      {required String companyId, required String cartegoryId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final productCartRepo = CartegoryRepository(firestore);
      return productCartRepo.deleteCartegory(
          companyId: companyId, cartegoryId: cartegoryId);
    });
    return state.hasError ? false : true;
  }
}
