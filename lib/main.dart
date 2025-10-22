import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/dashboard/main_screen.dart';
import 'package:testapp/utils/custom_colors.dart';

void main() => runApp(const FitnessApp());

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: CustomColors.black,
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
      ),
      home: const BottomNavScreen(),
    );
  }
}
