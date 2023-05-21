import 'package:field_zoom_pro_web/features/authentication/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AppUser _userFromFirebase(User? firebaseUser) {
    return firebaseUser == null ? AppUser(null) : AppUser(firebaseUser.uid);
  }

  Stream<AppUser> onAuthStateChanges() {
    return FirebaseAuth.instance
        .authStateChanges()
        .map((event) => _userFromFirebase(event));
  }

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  // sigin in with email and password

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  // Future<void> saveDeviceToken() async {
  //   final fcm = FirebaseMessaging.instance;

  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //   String? fcmToken = await fcm.getToken();
  //   if (fcmToken != null) {
  //     FirebaseFirestore.instance.collection("users").doc(uid).update(
  //       {
  //         "token": fcmToken,
  //         "platform": Platform.operatingSystem,
  //       },
  //     );
  //   }
  // }
}
