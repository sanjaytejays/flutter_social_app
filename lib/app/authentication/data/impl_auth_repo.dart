import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medcon/app/authentication/domain/model/user_model.dart';
import 'package:medcon/app/authentication/domain/repo/auth_repo.dart';

// Authentication Implimentation repo will have core functionality and logics of methods of authentication
class ImplAuthRepo implements AuthRepo {
  // instance..............................................
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // register user using email and password................
  @override
  Future<AppUserModel?> register({
    required String name,
    required String email,
    required String password,
    required String accountType,
  }) async {
    try {
      // register in firebase
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      AppUserModel user = AppUserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        accountType: accountType,
      );

      // create user in firestore
      await _firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      // return user
      return user;
    } catch (e) {
      // throw error
      throw Exception("REGISTER ERROR......$e");
    }
  }

  // get current user......................................
  @override
  Future<AppUserModel?> getCurrentUser() async {
    // get current user
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return null;
    }

    // return user
    return AppUserModel(
      uid: currentUser.uid,
      email: currentUser.email!,
      name: '',
      accountType: '',
    );
  }

  // login user using email and password...................
  @override
  Future<AppUserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // login with firebase
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // create user
      AppUserModel user = AppUserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
        accountType: '',
      );
      // return user
      return user;
    } catch (e) {
      throw Exception("LOGIN ERROR......$e");
    }
  }

  // logout user...........................................
  @override
  Future<void> logout() async {
    // sign out
    await _firebaseAuth.signOut();
  }
}
