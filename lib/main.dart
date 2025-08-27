import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lisan_app/pages/exercise/lesson_template.dart';
import 'package:lisan_app/pages/exercise/lesson_completion_page.dart';
import 'package:lisan_app/root_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lisan - Learn Amharic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFF1CC06),
          secondary: Color(0xFFF1CC06),
          surface: Color(0xFF1E2127),
          onPrimary: Color(0xFF14161B),
          onSecondary: Color(0xFF14161B),
          onSurface: Color(0xFFE4E4E7),
          error: Colors.red,
        ),
        scaffoldBackgroundColor: const Color(0xFF14161B),
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: LessonTemplate(
        exercises: [
          Center(child: Text('Exercise 1 Placeholder')),
          Center(child: Text('Exercise 2 Placeholder')),
          Center(child: Text('Exercise 3 Placeholder')),
        ],
        onLessonCompletion: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LessonCompletionPage()),
        ),
        validateAnswer: (index) => true,
        getFeedbackMessage: (index) => 'Feedback for exercise $index',
        getCorrectAnswer: (index) => 'Correct answer for exercise $index',
        onExerciseRequeued: (exercise) => print('Exercise requeued: $exercise'),
      ),
    );
  }
}
