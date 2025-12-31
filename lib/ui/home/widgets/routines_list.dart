import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:too_many_tabs/domain/models/routines/routine_summary.dart';
import 'package:too_many_tabs/ui/home/view_models/destination_bucket.dart';
import 'package:too_many_tabs/ui/home/view_models/home_viewmodel.dart';
import 'package:too_many_tabs/ui/home/widgets/menu_item.dart';
import 'package:too_many_tabs/ui/home/widgets/menu_popup.dart';
import 'package:too_many_tabs/ui/home/widgets/routine.dart';
import 'package:too_many_tabs/ui/home/widgets/routine_menu.dart';

class RoutinesList extends StatefulWidget {
  const RoutinesList({super.key, required this.viewModel, required this.onTap});

  final HomeViewmodel viewModel;
  final void Function(int) onTap;

  @override
  createState() => _RoutinesListState();
}

class _RoutinesListState extends State<RoutinesList> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  RoutineSummary? tappedRoutine;
  MenuItem? popup;

  @override
  build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(bottom: 150, top: 10),
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Stack(
            children: [
              FadingEdgeScrollView.fromScrollView(
                gradientFractionOnEnd: 0.8,
                gradientFractionOnStart: 0,
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverSafeArea(
                      minimum: EdgeInsets.only(bottom: 120),
                      sliver: SliverList.builder(
                        itemCount: widget.viewModel.routines.length,
                        itemBuilder: (_, index) {
                          final routineId = widget.viewModel.routines[index].id;
                          return Column(
                            children: [
                              Routine(
                                key: ValueKey(routineId),
                                routine: widget.viewModel.routines[index],
                                onTap: () {
                                  widget.onTap(index);
                                  setState(() {
                                    if (tappedRoutine == null ||
                                        (tappedRoutine != null &&
                                            tappedRoutine!.id != routineId)) {
                                      tappedRoutine =
                                          widget.viewModel.routines[index];
                                    } else {
                                      tappedRoutine = null;
                                    }
                                  });
                                },
                                startStopSwitch: () async {
                                  await widget.viewModel.startOrStopRoutine
                                      .execute(routineId);
                                  return widget
                                      .viewModel
                                      .startOrStopRoutine
                                      .completed;
                                },
                                archive: () async {
                                  await widget.viewModel.archiveOrBinRoutine
                                      .execute((
                                        routineId,
                                        DestinationBucket.backlog,
                                      ));
                                },
                              ),
                              tappedRoutine != null &&
                                      tappedRoutine!.id == routineId &&
                                      popup == null
                                  ? RoutineMenu(
                                      onClose: () {
                                        setState(() {
                                          popup = null;
                                        });
                                      },
                                      popup: (item) {
                                        setState(() {
                                          popup = item;
                                        });
                                      },
                                      routine: tappedRoutine!,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              MenuPopup(
                routine: tappedRoutine,
                viewModel: widget.viewModel,
                menu: popup,
                close: () {
                  setState(() {
                    popup = null;
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
