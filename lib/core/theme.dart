import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontSize {
  static const small = 12.0;
  static const standard = 14.0;
  static const standardUp = 16.0;
  static const medium = 13.0;
  static const large = 26.0;
}

class DefaultColors {
  static const greyText = Color(0xffb3b9c9);
  static const whiteText = Color(0xffFFFFFF);
  static const senderMessage = Color(0xff7a8194);
  static const receiverMessage = Color(0xff3d4354);
  static const sentMessage = Color(0xffF5F5F5);
  static const messageListPage = Color(0xff292f3f);
  static const buttonColor = Color(0xff7a8194);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xff1b202d),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.alegreyaSans(
          fontSize: FontSize.medium,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.alegreyaSans(
          fontSize: FontSize.large,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.alegreyaSans(
          fontSize: FontSize.standardUp,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.alegreyaSans(
          fontSize: FontSize.standard,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.alegreyaSans(
          fontSize: FontSize.standardUp,
          color: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xffF5F5F5),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.alegreyaSans(
          fontSize: FontSize.medium,
          color: Colors.black,
        ),
        titleLarge: GoogleFonts.alegreyaSans(
          fontSize: FontSize.large,
          color: Colors.black,
        ),
        bodySmall: GoogleFonts.alegreyaSans(
          fontSize: FontSize.standardUp,
          color: Colors.black,
        ),
        bodyMedium: GoogleFonts.alegreyaSans(
          fontSize: FontSize.standard,
          color: Colors.black,
        ),
        bodyLarge: GoogleFonts.alegreyaSans(
          fontSize: FontSize.standardUp,
          color: Colors.black,
        ),
      ),
    );
  }
}
