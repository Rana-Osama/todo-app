import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/FirebaseErrorCodes.dart';
import 'package:todo_app/Providers/AuthProvider.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/common/CustomFormField.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';

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
            image: AssetImage(
          'assets/images/auth_pattern.png'
        ),
          fit: BoxFit.fill
        )
      ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.all(12),
            child: Form(
              key: formKey ,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 270,),
                    CustomFormField(hint: 'Full Name',keyboardType: TextInputType.name,
                    validator: (text){
                      if (text == null || text.trim().isEmpty){
                        return 'Please enter full name';
                      }
                      return null;
                    },controller: fullName
                    ,),
                    CustomFormField(hint: 'User Name',keyboardType: TextInputType.name,
                        validator: (text){
                          if (text == null || text.trim().isEmpty){
                            return 'Please enter user name';
                          }
                          return null;
                        },controller: userName,
                    ),
                    CustomFormField(hint: 'Email',keyboardType: TextInputType.emailAddress,
                        validator: (text){
                          if (text == null || text.trim().isEmpty){
                            return 'Please enter email';
                          }
                          if (!isValidEmail(text)){
                            return 'Email bad format';
                          }
                          return null;
                        },controller: email,
                    ),
                    CustomFormField(hint: 'Password',keyboardType: TextInputType.text,secureText: true,
                        validator: (text){
                          if (text == null || text.trim().isEmpty){
                            return 'Please enter password';
                          }
                          if (text.length < 6 ){
                            return 'Password should be at least 6 characters';
                          }
                          return null;
                        },controller: password,
                        ),
                    CustomFormField(hint: 'Password Confirmation',keyboardType: TextInputType.text,secureText: true,
                        validator: (text){
                          if (text == null || text.trim().isEmpty){
                            return 'Please enter password confirmation';
                          }
                          if(password.text != text){
                            return "Password doesn't match";
                          }

                          return null;
                        }
                        ,controller: passwordConfirmation,
                    ),
                    SizedBox(height: 25,),
                    ElevatedButton(onPressed: (){
                      createAccount();
                    }, child: Text('Create Account'))

                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void createAccount() async {
    if (formKey.currentState?.validate()== false){
      return ;
    }
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      DialogUtils.showMessage(context, 'Loading...');
      await authProvider.register(userName.text, fullName.text, email.text, password.text);
      DialogUtils.showMessage(context, 'Registered successfully',
      positiveActionTitle: 'Ok',
      positiveAction: (){
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrorCodes.weak_password) {
        DialogUtils.showMessage(context,'The password provided is too weak.');
      } else if (e.code == FirebaseErrorCodes.email_used) {
        DialogUtils.showMessage(context ,'The account already exists for that email.');
      }
    } catch (e) {
      DialogUtils.showMessage(context,'Something went wrong ');
    }

  }
}

