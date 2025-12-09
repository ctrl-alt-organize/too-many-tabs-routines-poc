import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RoutineAction extends StatelessWidget {
  const RoutineAction({
    super.key,
    required this.onPressed,
    required this.state,
    required this.icon,
    required this.label,
  });

  final Function(BuildContext) onPressed;
  final RoutineActionState state;
  final IconData icon;
  final String label;

  @override
  build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color foreground, background;
    switch (state) {
      case RoutineActionState.toStart:
        foreground = darkMode ? colorScheme.primary : colorScheme.onPrimary;
        background = darkMode
            ? colorScheme.surfaceContainerLow
            : colorScheme.primary;
        break;
      case RoutineActionState.toStop:
        foreground = darkMode ? colorScheme.onSurface : colorScheme.onTertiary;
        background = darkMode
            ? colorScheme.surfaceContainerLow
            : colorScheme.tertiary;
        break;
      case RoutineActionState.toArchive:
      case RoutineActionState.toTrash:
        foreground = darkMode
            ? colorScheme.onSurface
            : colorScheme.onInverseSurface;
        background = darkMode
            ? colorScheme.surfaceContainerLow
            : colorScheme.inverseSurface;
        break;
      case RoutineActionState.toReschedule:
      case RoutineActionState.toRestore:
        foreground = colorScheme.primary;
        background = colorScheme.surface;
        break;
    }
    return SlidableAction(
      backgroundColor: background,
      foregroundColor: foreground,
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}

enum RoutineActionState {
  toStart(0),
  toStop(1),
  toArchive(2),
  toTrash(3),
  toReschedule(4),
  toRestore(5);

  const RoutineActionState(this.code);

  final int code;
}
