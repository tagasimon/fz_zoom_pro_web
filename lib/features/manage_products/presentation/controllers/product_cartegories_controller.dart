import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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

  Future<String?> getUserDownloadUrl(String folderName) async {
    state = const AsyncValue.loading();
    try {
      final url = await updateProfilePic(folderName: folderName);
      state = const AsyncValue.data(null);
      return url;
    } catch (e, stk) {
      log("Error: $e", stackTrace: stk);
      state = AsyncValue.error(e, stk);
      return null;
    }
  }

  Future<String?> updateProfilePic({required String folderName}) async {
    final dn = DateTime.now();
    String? imgUrl;
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      final ref = FirebaseStorage.instance
          .ref()
          .child(folderName)
          .child("${dn.year}")
          .child("${dn.month}")
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await ref.putData(fileBytes).whenComplete(() async {
        imgUrl = await ref.getDownloadURL();
      });
    }
    return imgUrl;
  }
}
