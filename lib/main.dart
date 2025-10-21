import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/pages/amharic_handwriting_page.dart';
import 'package:lisan_app/pages/auth/login_page.dart';

import 'package:lisan_app/root_screen.dart';
import 'package:lisan_app/services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lisan - Learn Amharic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: DesignColors.primary,
          secondary: DesignColors.primary,
          surface: DesignColors.backgroundCard,
          onPrimary: DesignColors.backgroundDark,
          onSecondary: DesignColors.backgroundDark,
          onSurface: Color(0xFFE4E4E7),
          error: DesignColors.error,
        ),
        scaffoldBackgroundColor: DesignColors.backgroundDark,
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),

      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Error loading auth status')),
            );
          } else {
            final isLoggedIn = snapshot.data ?? false;
            return RootScreen();
            // return isLoggedIn ? LoginPage() : RootScreen();
          }
        },
      ),
    );
  }
}
