import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Providers/AuthProvider.dart';
import 'package:todo_app/ui/common/MyThemeData.dart';
import 'package:todo_app/Providers/SettingsProvider.dart';
import 'package:todo_app/splash/splashScreen.dart';
import 'package:todo_app/ui/home/HomeScreen.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';
import 'package:todo_app/ui/register/RegisterScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var settingsProvider = SettingsProvider();
  var authProvider = AuthProvider();
  await settingsProvider.loadTheme();
  await settingsProvider.loadLocal();
  await authProvider.retrieveUserFromDatabase();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => authProvider),
    ChangeNotifierProvider(create: (context) => settingsProvider)
  ], child: const MyApp()));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, settingsProvider, _) {
      return MaterialApp(
        title: 'TO DO',
        theme: MyThemeData.LightTheme,
        darkTheme: MyThemeData.DarkTheme,
        themeMode: settingsProvider.currentTheme,
        routes: {
          RegisterScreen.routeName: (_) => RegisterScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          SplashScreen.routeName: (_) => SplashScreen()
        },
        initialRoute: SplashScreen.routeName,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('ar'), // Arabic
        ],
        locale: Locale(settingsProvider.currentLocale),
      );
    });
  }
}
