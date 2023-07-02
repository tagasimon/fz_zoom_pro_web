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

  // Future<void> downloadImage(String imageUrl) async {
  //   state = const AsyncValue.loading();
  //   try {
  //     // first we make a request to the url like you did
  //     // in the android and ios version
  //     final http.Response r = await http.get(Uri.parse(imageUrl));

  //     // we get the bytes from the body
  //     final data = r.bodyBytes;
  //     // and encode them to base64
  //     final base64data = base64Encode(data);

  //     // then we create and AnchorElement with the html package
  //     final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

  //     // set the name of the file we want the image to get
  //     // downloaded to
  //     a.download = 'download.jpg';

  //     // and we click the AnchorElement which downloads the image
  //     a.click();
  //     // finally we remove the AnchorElement
  //     a.remove();
  //     state = const AsyncValue.data(null);
  //   } catch (e, s) {
  //     state = AsyncValue.error(e, s);
  //     debugPrint("Error $e $s");
  //   }
  // }
}
