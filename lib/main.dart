import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/pages/auth/login_page.dart';
import 'package:lisan_app/pages/exercise/fidel/fidel_pronunciation_choice_exercise_content.dart';
import 'package:lisan_app/pages/exercise/fidel/listening_fidel_choice_exercise_content.dart';
import 'package:lisan_app/pages/exercise/fidel/pronunciation_fidel_choice_exercise_content.dart';
import 'package:lisan_app/pages/exercise/fidel/trace_fidel_exercise_content.dart';

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

            return TraceFidelExerciseContent.fromJson({
              "type": "trace_fidel",
              "character": "ኡ",
            });
            // return FidelPronunciationChoiceExerciseContent.fromJson({
            //   "type": "fidel_pronunciation_choice",
            //   "character": "ሁ",
            //   "options": ["fa", "hu", "haa"],
            //   "correct_answer": "hu",
            // });
            // return PronunciationFidelChoiceExerciseContent.fromJson({
            //   "type": "pronunciation_fidel_choice",
            //   "pronunciation": "su",
            //   "options": ["ደ", "ተ", "ፍ", "ሱ"],
            //   "correct_answer": "ሱ",
            // });
            // return ListeningFidelChoiceExerciseContent.fromJson({
            //   "type": "listening_fidel_choice",
            //   "audio_asset_path": "assets/fidel_audio/ፎ.mp3",
            //   "options": ["ፎ", "ዩ", "ማ", "ቹ"],
            //   "correct_answer": "ፎ",
            // });
            // return isLoggedIn ? LoginPage() : RootScreen();
          }
        },
      ),
    );
  }
}
