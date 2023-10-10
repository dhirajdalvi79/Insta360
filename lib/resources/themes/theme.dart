import 'package:flutter/material.dart';
import '../utilities/colors.dart';

/// Custom themes for app
class MyAppTheme {
  // Light theme data
  static ThemeData light = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: lightThemeBaseColor,
      ),
      scaffoldBackgroundColor: lightThemeBaseColor,
      textTheme: const TextTheme(
        bodySmall: TextStyle(fontSize: 15, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 15, color: Colors.black),
        bodyLarge: TextStyle(fontSize: 15, color: Colors.black),
        labelSmall: TextStyle(fontSize: 15, color: Colors.black),
        labelMedium: TextStyle(fontSize: 15, color: Colors.black),
        labelLarge: TextStyle(fontSize: 15, color: Colors.black),
      ),
      primaryTextTheme: const TextTheme(
        bodySmall: TextStyle(fontSize: 15, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 15, color: Colors.black),
        bodyLarge: TextStyle(fontSize: 15, color: Colors.black),
        labelSmall: TextStyle(fontSize: 15, color: Colors.black),
        labelMedium: TextStyle(fontSize: 15, color: Colors.black),
        labelLarge: TextStyle(fontSize: 15, color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(fontSize: 18, color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black),
          suffixIconColor: Colors.black),
      dialogBackgroundColor: Colors.grey,
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: primaryColor,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: lightThemeBaseColor,
        headerBackgroundColor: primaryColor,
        headerForegroundColor: lightThemeBaseColor,
        todayBackgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
        todayForegroundColor: MaterialStatePropertyAll<Color>(Colors.white),
      ));

  // Dark theme data
  static ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: darkThemeBaseColor,
      ),
      scaffoldBackgroundColor: darkThemeBaseColor,
      textTheme: const TextTheme(
        bodySmall: TextStyle(fontSize: 15, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 15, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 15, color: Colors.white),
        labelSmall: TextStyle(fontSize: 15, color: Colors.white),
        labelMedium: TextStyle(fontSize: 15, color: Colors.white),
        labelLarge: TextStyle(fontSize: 15, color: Colors.white),
      ),
      primaryTextTheme: const TextTheme(
        bodySmall: TextStyle(fontSize: 15, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 15, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 15, color: Colors.white),
        labelSmall: TextStyle(fontSize: 15, color: Colors.white),
        labelMedium: TextStyle(fontSize: 15, color: Colors.white),
        labelLarge: TextStyle(fontSize: 15, color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(fontSize: 18, color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          suffixIconColor: Colors.white),
      dialogBackgroundColor: Colors.black38,
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: primaryColor,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.white),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: darkThemeBaseColor,
        headerBackgroundColor: primaryColor,
        headerForegroundColor: darkThemeBaseColor,
        todayBackgroundColor: MaterialStatePropertyAll<Color>(primaryColor),
        todayForegroundColor: MaterialStatePropertyAll<Color>(Colors.white),
      ));
}
