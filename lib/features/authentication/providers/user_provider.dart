import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final userRepoProvider = Provider<UsersRepository>((ref) {
  final firestore = ref.watch(firestoreInstanceProvider);
  return UsersRepository(firestore);
});

final userInfoProvider = StreamProvider.autoDispose<UserModel>((ref) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  return ref.watch(userRepoProvider).watchUser(id: uid);
});
