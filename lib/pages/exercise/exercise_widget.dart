import 'package:flutter/material.dart';

/// Abstract base class for exercise widgets.
/// Requires subclasses to implement copyWith for cloning with modified parameters.
abstract class ExerciseWidget extends StatefulWidget {
  final bool isRequeued;

  const ExerciseWidget({super.key, this.isRequeued = false});

  /// Abstract copyWith method that subclasses must implement.
  /// Each subclass defines its own parameters (e.g., isRequeued, data, etc.).
  ExerciseWidget copyWith({bool? isRequeued, Key? key});
}
