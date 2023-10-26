import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/SettingsProvider.dart';
import 'package:todo_app/database/UsersDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/common/CustomFormField.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/register/RegisterScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          appBar: AppBar(
              title: Center(child: Text(AppLocalizations.of(context)!.login)),
              titleTextStyle: Theme.of(context).textTheme.headlineSmall),
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
                      hint: AppLocalizations.of(context)!.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.email_error1;
                        }
                        if (!isValidEmail(text)) {
                          return AppLocalizations.of(context)!.email_bad_error;
                        }
                        return null;
                      },
                      controller: email,
                    ),
                    CustomFormField(
                      hint: AppLocalizations.of(context)!.password,
                      keyboardType: TextInputType.text,
                      secureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.password_error;
                        }
                        if (text.length < 6) {
                          return AppLocalizations.of(context)!
                              .password_error_num;
                        }
                        return null;
                      },
                      controller: password,
                      icon: Icons.remove_red_eye_rounded,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: Text(AppLocalizations.of(context)!.no_account))
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
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.loading,
          isCancelable: false);
      await authProvider.login(email.text, password.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, AppLocalizations.of(context)!.logged_in,
          positiveActionTitle: AppLocalizations.of(context)!.ok,
          positiveAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrorCodes.user_not_found ||
          e.code == FirebaseErrorCodes.wrong_password ||
          e.code == FirebaseErrorCodes.invalid_credentials) {
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.wrong_email_password,
            positiveActionTitle: AppLocalizations.of(context)!.ok);
      }
    }
  }
}
