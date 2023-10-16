import 'package:flutter/material.dart';
import 'package:todo_app/ui/common/CustomFormField.dart';

import '../../ValidationUtils.dart';

class LoginScreen extends StatelessWidget {
 static const String routeName = 'login';

 TextEditingController email = TextEditingController();
 TextEditingController password = TextEditingController();

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

                    SizedBox(height: 25,),
                    ElevatedButton(onPressed: (){
                      login();
                    }, child: Text('Login'))

                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void login() {
    if (formKey.currentState?.validate()== false){
      return ;
    }
  }
}

