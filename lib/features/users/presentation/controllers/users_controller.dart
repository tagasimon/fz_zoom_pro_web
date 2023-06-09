import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final usersControllerProvider =
    StateNotifierProvider.autoDispose<UsersController, AsyncValue>((ref) {
  return UsersController(ref.watch(firestoreInstanceProvider));
});

class UsersController extends StateNotifier<AsyncValue> {
  final FirebaseFirestore firestore;
  UsersController(this.firestore) : super(const AsyncData(null));

  Future<bool> updateUser({required UserModel user}) async {
    final userRepo = UsersRepository(firestore);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => userRepo.updateUserByCompanyAndUserId(user: user));
    return state.hasError ? false : true;
  }

  Future<String?> createAssociateAccount({
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      state = const AsyncValue.loading();
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e, stk) {
      userCredential = null;
      state = AsyncValue.error(e, stk);

      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
    }

    await app.delete();
    return Future.sync(
        () => userCredential != null ? userCredential.user!.uid : null);
  }

  Future<bool> registerAssociate({required UserModel user}) async {
    const usersDb = 'FZ_USERS';
    try {
      await firestore.collection(usersDb).add(user.toMap());
      state = const AsyncValue.data(true);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }

  Future<bool> editUser({required UserModel user}) async {
    const usersDb = 'FZ_USERS';
    try {
      state = const AsyncValue.loading();
      await firestore
          .collection(usersDb)
          .where("id", isEqualTo: user.id)
          .get()
          .then((value) {
        value.docs.first.reference.update(user.toMap());
      });
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }
}
