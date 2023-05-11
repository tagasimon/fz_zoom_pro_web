import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final userRepoProvider = Provider<UsersRepository>((ref) => UsersRepository());

final userInfoProvider = StreamProvider<UserModel>((ref) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  return ref.watch(userRepoProvider).watchUser(id: uid);
});
