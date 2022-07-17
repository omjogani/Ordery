
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }
  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // await ApplicationDatabaseService().insertDummyData();
    // await OrderDatabaseService().insertDummyData();
    
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void showSnackbar(BuildContext context, String textToDisplay) {
    // TODO: Custom Snackbar display here...
    final snackBar = SnackBar(content: Text(textToDisplay));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
