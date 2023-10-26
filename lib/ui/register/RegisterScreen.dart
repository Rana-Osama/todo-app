import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/FirebaseErrorCodes.dart';
import 'package:todo_app/Providers/AuthProvider.dart';
import 'package:todo_app/database/UsersDao.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/common/CustomFormField.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';
import 'package:todo_app/database/model/User.dart' as MyUser;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ValidationUtils.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullName = TextEditingController();

  TextEditingController userName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController passwordConfirmation = TextEditingController();

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
              title: Center(
                  child: Text(AppLocalizations.of(context)!.create_account)),
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
                      height: 180,
                    ),
                    CustomFormField(
                      hint: AppLocalizations.of(context)!.full_name,
                      keyboardType: TextInputType.name,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.full_name_error;
                        }
                        return null;
                      },
                      controller: fullName,
                    ),
                    CustomFormField(
                      hint: AppLocalizations.of(context)!.user_name,
                      keyboardType: TextInputType.name,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.user_name_error;
                        }
                        return null;
                      },
                      controller: userName,
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
                    CustomFormField(
                      hint: AppLocalizations.of(context)!.password_confirmation,
                      keyboardType: TextInputType.text,
                      secureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .password_confirmation_error;
                        }
                        if (password.text != text) {
                          return AppLocalizations.of(context)!
                              .password_confirmation_error_match;
                        }

                        return null;
                      },
                      controller: passwordConfirmation,
                      icon: Icons.remove_red_eye_rounded,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          createAccount();
                        },
                        child: Text(
                            AppLocalizations.of(context)!.create_account,
                            style: Theme.of(context).textTheme.titleLarge)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Text(AppLocalizations.of(context)!.have_account))
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void createAccount() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      DialogUtils.showMessage(context, AppLocalizations.of(context)!.loading);
      await authProvider.register(
          userName.text, fullName.text, email.text, password.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
          context, AppLocalizations.of(context)!.registered_successfully,
          positiveActionTitle: AppLocalizations.of(context)!.ok,
          positiveAction: () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrorCodes.weak_password) {
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.weak_password);
      } else if (e.code == FirebaseErrorCodes.email_used) {
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.email_used);
      }
    } catch (e) {
      DialogUtils.showMessage(
          context, AppLocalizations.of(context)!.something_wrong);
    }
  }
}
