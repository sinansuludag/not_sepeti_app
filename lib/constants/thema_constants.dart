import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get themeData {
    return ThemeData(
      indicatorColor: Colors.white,
      primaryColor: Colors.redAccent,
      primaryColorDark: Colors.black,
      primaryColorLight: Colors.white,
      primarySwatch: Colors.grey,
      dialogBackgroundColor: Colors.white,
      //------
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.grey.shade100,
      ),
      //------
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: Colors.redAccent.shade700,
        elevation: 4,
      ),
      //------
      colorScheme: ColorScheme.fromSwatch(
        accentColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      //------
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'EduAUVICWANTHand',
      //------
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      //------
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.red.shade600,
      ),
      //------
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      //------
      snackBarTheme: SnackBarThemeData(backgroundColor: Colors.red.shade400),
      //------
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.blue),
        ),
      ),
    );
  }
}
