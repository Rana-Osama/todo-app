import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';

import '../Providers/AuthProvider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),(){
      navigate(context);
    });
    return Scaffold(
      body: Image.asset('assets/images/splash.png'),
    );
  }

  void navigate(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    if (provider.isLoggedInBefore()){
      provider.retrieveUserFromDatabase();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
    else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }

  }
}
