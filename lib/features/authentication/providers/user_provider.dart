import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final userRepoProvider = Provider<UsersRepository>((ref) {
  final firestore = ref.watch(firestoreInstanceProvider);
  return UsersRepository(firestore);
});

final userInfoProvider = StreamProvider.autoDispose<UserModel>((ref) {
  final firebaseAuthProv = ref.watch(firebaseAuthProvider);
  final uid = firebaseAuthProv.currentUser!.uid;
  return ref.watch(userRepoProvider).watchUser(id: uid);
});

final findUserByIdProvider =
    StreamProvider.autoDispose.family<UserModel, String>((ref, userId) {
  return ref.watch(userRepoProvider).watchUser(id: userId);
});
