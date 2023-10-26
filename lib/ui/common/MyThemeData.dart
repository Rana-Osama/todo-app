import 'package:flutter/material.dart';

class MyThemeData {
  static const Color lightPrimary = Colors.blue;
  static const Color lightSecondary = Color(0xFFDFECDB);
  static const Color darkPrimary = Colors.blue;
  static const Color darkSecondary = Color(0xFF060e1e);
  static const Color darkTertiary = Color(0xff141922);

  static ThemeData LightTheme = ThemeData(
      textTheme: const TextTheme(
          headlineSmall: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
          titleMedium: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w400, color: Colors.black),
          bodyMedium: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black),
          titleLarge: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),
      labelLarge: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black
      )
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.blue),
      useMaterial3: false,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
      ),
      scaffoldBackgroundColor: lightSecondary,
      colorScheme: ColorScheme.fromSeed(
          seedColor: lightPrimary,
          primary: lightPrimary,
          secondary: lightSecondary,
          tertiary: Color(0xff61E757),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          background: lightSecondary),
      cardTheme: CardTheme(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: MyThemeData.lightSecondary,
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.white),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: Colors.white));

  static ThemeData DarkTheme = ThemeData(
      textTheme: const TextTheme(
          headlineSmall: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
          titleMedium: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white),
          bodyMedium: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),
          titleLarge: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black),
          labelLarge: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black
          )
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.blue),
      useMaterial3: false,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 30),
      ),
      scaffoldBackgroundColor: darkSecondary,
      colorScheme: ColorScheme.fromSeed(
          seedColor: darkPrimary,
          primary: darkPrimary,
          secondary: darkSecondary,
          tertiary: Color(0xff61E757),
          onPrimary: Colors.black,
          onSecondary: darkTertiary,
          background: darkSecondary),
      cardTheme: CardTheme(
          color: darkTertiary,
          // surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: darkTertiary),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.grey,
      ),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: darkTertiary));
}
