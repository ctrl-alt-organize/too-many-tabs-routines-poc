import 'package:flutter/material.dart';
import 'package:too_many_tabs/domain/models/routines/routine_summary.dart';

class RoutineMenu extends StatelessWidget {
  const RoutineMenu({super.key, required this.onClose, required this.routine});
  final void Function() onClose;
  final RoutineSummary routine;

  @override
  build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 10,
        children: [
          _MenuItem(
            icon: routine.running ? Icons.stop_circle : Icons.play_circle,
            label: routine.running ? "Stop" : "Start",
          ),
          _MenuItem(icon: Icons.star, label: "Set goal"),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.primaryContainer,
        ),
        child: Row(
          spacing: 7,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            Icon(icon, color: colorScheme.onPrimaryContainer),
          ],
        ),
      ),
    );
  }
}
