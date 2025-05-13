import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your actual page widgets
import 'tour_page.dart';
import 'tour_stepper_page.dart';

final StateProvider<int> selectedIndexProvider = StateProvider<int>((ref) => 0);

class Structure extends ConsumerStatefulWidget {
  const Structure({super.key});

  @override
  ConsumerState<Structure> createState() => _StructureState();
}

class _StructureState extends ConsumerState<Structure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(
              flex: 1,
              child: TourStepperPage(), // 👈 This shows first
            ),
            Divider(height: 1),
           
          ],
        ),
      ),
    );
  }
}
