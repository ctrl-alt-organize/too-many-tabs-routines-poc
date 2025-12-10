import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:too_many_tabs/domain/models/routines/routine_summary.dart';
import 'package:too_many_tabs/ui/core/ui/routine_action.dart';
import 'package:too_many_tabs/ui/home/widgets/routine_goal_label.dart';
import 'package:too_many_tabs/ui/home/widgets/routine_spent_dynamic_label.dart';

class Routine extends StatelessWidget {
  const Routine({
    super.key,
    required this.routine,
    required this.onTap,
    required this.onSwitch,
    required this.archive,
    required this.bin,
  });

  final RoutineSummary routine;
  final GestureTapCallback onTap;
  final Function(BuildContext) onSwitch, archive, bin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    return Slidable(
      key: ValueKey(routine.id),
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          RoutineAction(
            icon: routine.running ? Icons.stop : Icons.timer,
            state: routine.running
                ? RoutineActionState.toStop
                : RoutineActionState.toStart,
            label: routine.running ? 'Stop' : 'Start',
            onPressed: onSwitch,
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          RoutineAction(
            icon: Icons.delete,
            state: RoutineActionState.toTrash,
            label: 'Trash',
            onPressed: archive,
          ),
          RoutineAction(
            icon: Icons.archive,
            state: RoutineActionState.toArchive,
            label: 'Backlog',
            onPressed: archive,
          ),
        ],
      ),
      child: InkWell(
        splashColor: colorScheme.primaryContainer,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .5 + 20,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: routine.running
                              ? (darkMode
                                    ? colorScheme.primary
                                    : colorScheme.primary)
                              : (darkMode
                                    ? colorScheme.primaryContainer
                                    : colorScheme.primaryFixed),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                routine.name.trim(),
                                style: TextStyle(fontSize: 16),
                                // overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            routine.running
                                ? RoutineSpentDynamicLabel(
                                    restorationId:
                                        'routine_spent_dynamic_label_${routine.id}',
                                    key: ValueKey(routine.id),
                                    spent: routine.spent,
                                    lastStarted: routine.lastStarted!,
                                  )
                                : RoutineSpentLabel(spent: routine.spent),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: routine.running
                    ? RoutineGoalDynamicLabel(
                        restorationId:
                            'routine_goal_dynamic_label_${routine.id}',
                        key: ValueKey(routine.id),
                        spent: routine.spent,
                        goal: routine.goal,
                        running: routine.running,
                        lastStarted: routine.lastStarted!,
                      )
                    : RoutineGoalLabel(
                        spent: routine.spent,
                        goal: routine.goal,
                        running: routine.running,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
