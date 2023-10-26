import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';

import '../Providers/AuthProvider.dart';
import '../Providers/SettingsProvider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    var settingsProvider = SettingsProvider();

    Future.delayed(Duration(seconds: 2), () {
      navigate(context);
    });
    return FutureBuilder(
        future: settingsProvider.loadTheme(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            String? theme = settingsProvider.getTheme();
            return Scaffold(
              body: theme == 'Light'
                  ? Image.asset('assets/images/splash.png')
                  : Image.asset('assets/images/splash_dark.png'),
            );
          }
        });
  }

  void navigate(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    if (provider.isLoggedInBefore()) {
      provider.retrieveUserFromDatabase();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }
}
