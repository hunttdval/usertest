import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_phone_number/models/users.dart';
import 'package:login_phone_number/screens/home.dart';
import 'package:login_phone_number/screens/login.dart';

class AuthService {
  //handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }

  //sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

//sign in
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  //sign in with OTP
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    print(user.displayName);
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }
}
