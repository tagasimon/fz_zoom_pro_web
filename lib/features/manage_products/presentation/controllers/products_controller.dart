import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class ProductsController extends StateNotifier<AsyncValue<void>> {
  final FirebaseFirestore firestore;
  ProductsController(this.firestore) : super(const AsyncValue.data(null));

  Future<bool> addNewProduct({
    required ProductModel productModel,
  }) async {
    final productsRepo = ProductRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => productsRepo.addNewProduct(productModel: productModel));
    return state.hasError ? false : true;
  }

  Future<bool> editProduct({
    required String productId,
    required ProductModel newInfo,
  }) async {
    final productsRepo = ProductRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => productsRepo.editProduct(productId: productId, newInfo: newInfo));
    return state.hasError ? false : true;
  }

  Future<bool> editProductVariable({
    required String productId,
    required Map<String, dynamic> newInfo,
  }) async {
    final productsRepo = ProductRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => productsRepo.editProductVariable(
        productId: productId, newInfo: newInfo));
    return state.hasError ? false : true;
  }

  // delete product
  Future<void> deleteProduct({
    required String productId,
  }) async {
    final productsRepo = ProductRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => productsRepo.deleteProduct(productId: productId));
  }

  Future<void> saveProductImageToFirestore(
    String downloadUrl,
    String productId,
  ) async {
    // TODOD Use Firebase Instance
    const productsDB = 'FZ_PRODUCTS';
    final ref = firestore
        .collection(productsDB)
        .where("id", isEqualTo: productId)
        .get();
    return ref.then(
        (doc) => doc.docs.first.reference.update({"productImg": downloadUrl}));
  }

  Future<bool> updateProduct({
    required ProductModel product,
  }) async {
    final productRepo = ProductRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => productRepo.updateProduct(product: product));
    return state.hasError ? false : true;
  }

  // delete Products
  Future<bool> deleteProductById(
      {required String companyId, required String productId}) async {
    final productRepo = ProductRepository(firestore);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => productRepo.deleteProductById(
        productId: productId, companyId: companyId));
    return state.hasError ? false : true;
  }
}
