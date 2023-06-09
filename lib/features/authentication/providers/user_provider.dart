import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final userRepoProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(ref.watch(firestoreInstanceProvider));
});

final userInfoProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final uid = ref.watch(firebaseAuthProvider).currentUser?.uid;
  if (uid == null) {
    return const Stream.empty();
  }
  return ref.watch(userRepoProvider).watchUser(id: uid);
});

final findUserByIdProvider =
    StreamProvider.autoDispose.family<UserModel, String>((ref, userId) {
  return ref.watch(userRepoProvider).watchUser(id: userId);
});
