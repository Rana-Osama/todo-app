import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../database/UsersDao.dart';
import '../database/model/User.dart' as MyUser;

class AuthProvider extends ChangeNotifier {
  User? firebaseAuthUser;
  MyUser.User? databaseUser;

  Future<void> register(
      String userName, String fullName, String email, String password) async {
    var result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await UsersDao.createUser(MyUser.User(
        id: result.user?.uid,
        fullName: fullName,
        userName: userName,
        email: email));
  }

  Future<void> login(String email, String password) async {
    var result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    var user = await UsersDao.getUser(result.user?.uid);
    databaseUser = user;
    firebaseAuthUser = result.user;
  }

  void logout() {
    databaseUser = null;
    FirebaseAuth.instance.signOut();
  }

  bool isLoggedInBefore() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<MyUser.User?> retrieveUserFromDatabase() async {
    firebaseAuthUser = FirebaseAuth.instance.currentUser;
    if (firebaseAuthUser != null) {
      databaseUser = await UsersDao.getUser(firebaseAuthUser!.uid);
    }
    if (databaseUser != null) {
      return databaseUser;
    }
    return null;
  }
}
