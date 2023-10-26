import 'package:flutter/material.dart';

class User {
  String? id;
  String? fullName;
  String? userName;
  String? email;
  //ThemeMode? theme;
  //String? locale;

  static const String collectionName = 'users';

  User({this.id, this.fullName, this.userName, this.email});

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'fullName': fullName,
      'userName': userName,
      'email': email,
      //  'theme' : theme,
      //  'locale': locale
    };
  }

  User.fromFireStore(Map<String, dynamic>? data)
      : this(
          id: data?['id'],
          fullName: data?['fullName'],
          userName: data?['userName'],
          email: data?['email'],
          // theme: data?['theme'],
          //  locale: data?['locale']
        );
}
