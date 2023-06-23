import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadImageControllerProvider =
    StateNotifierProvider<UploadImageController, AsyncValue>((ref) {
  return UploadImageController(ref.watch(firebaseStorageProvider));
});

class UploadImageController extends StateNotifier<AsyncValue> {
  final FirebaseStorage firebaseStorage;
  UploadImageController(this.firebaseStorage)
      : super(const AsyncValue.data(null));

  Future<String?> getUserDownloadUrl(String folderName) async {
    state = const AsyncValue.loading();
    try {
      final url = await updateProfilePic(folderName: folderName);
      state = const AsyncValue.data(null);
      return url;
    } catch (e, stk) {
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
      final ref = firebaseStorage
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
