import 'package:lisan_app/models/lesson_type.dart';

class LessonNode {
  final int id;
  final String title;
  final LessonType type;

  LessonNode({required this.id, required this.title, required this.type});
}