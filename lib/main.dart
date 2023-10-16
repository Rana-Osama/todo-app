import 'package:flutter/material.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';
import 'package:todo_app/ui/register/RegisterScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primaryColor: Colors.blue,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue
        ),
        scaffoldBackgroundColor: Color(0xFFDFECDB),
        useMaterial3: false,
      ),

      routes: {
        RegisterScreen.routeName : (_)=> RegisterScreen(),
        LoginScreen.routeName: (_)=> LoginScreen(),
        HomeScreen.routeName: (_)=>HomeScreen(),
      },
      initialRoute: HomeScreen.routeName,
    );
  }
}

