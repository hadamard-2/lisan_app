import 'dart:ui';
import 'package:lisan_app/models/lesson_node.dart';

class UnitData {
  final int id;
  final String title;
  final Color color;
  final List<LessonNode> lessons;

  UnitData({
    required this.id,
    required this.title,
    required this.color,
    required this.lessons,
  });
}