import 'package:field_zoom_pro_web/features/authentication/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  AuthRepository(this.firebaseAuth);
  AppUser _userFromFirebase(User? firebaseUser) {
    return firebaseUser == null ? AppUser(null) : AppUser(firebaseUser.uid);
  }

  Stream<AppUser> onAuthStateChanges() {
    return firebaseAuth
        .authStateChanges()
        .map((event) => _userFromFirebase(event));
  }

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  // sigin in with email and password

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  // Future<void> saveDeviceToken() async {
  //   final fcm = FirebaseMessaging.instance;

  //   String uid = firebaseAuth.currentUser!.uid;
  //   String? fcmToken = await fcm.getToken();
  //   if (fcmToken != null) {
  //     firestore.collection("users").doc(uid).update(
  //       {
  //         "token": fcmToken,
  //         "platform": Platform.operatingSystem,
  //       },
  //     );
  //   }
  // }
}
