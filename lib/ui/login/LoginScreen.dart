import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/UsersDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/common/CustomFormField.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/register/RegisterScreen.dart';

import '../../FirebaseErrorCodes.dart';
import '../../Providers/AuthProvider.dart';
import '../../ValidationUtils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/images/auth_pattern.png'),
                fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 270,
                    ),
                    CustomFormField(
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter email';
                        }
                        if (!isValidEmail(text)) {
                          return 'Email bad format';
                        }
                        return null;
                      },
                      controller: email,
                    ),
                    CustomFormField(
                      hint: 'Password',
                      keyboardType: TextInputType.text,
                      secureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter password';
                        }
                        if (text.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                      controller: password,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text('Login')),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: Text("Don't have account ?"))
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void login() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      DialogUtils.showLoading(context, 'Loading...', isCancelable: false);
      await authProvider.login(email.text, password.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'User logged in successfully',
          positiveActionTitle: 'Ok ', positiveAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrorCodes.user_not_found ||
          e.code == FirebaseErrorCodes.wrong_password ||
          e.code == FirebaseErrorCodes.invalid_credentials) {
        DialogUtils.showMessage(context, 'Wrong email or password',
            positiveActionTitle: 'Ok');
      }
    }
  }
}
