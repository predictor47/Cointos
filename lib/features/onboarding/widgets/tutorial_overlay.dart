import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/tutorial_service.dart';

class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;

  const TutorialOverlay({Key? key, required this.steps}) : super(key: key);

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class TutorialStep {
  final String title;
  final String description;
  final Offset position;

  TutorialStep({
    required this.title,
    required this.description,
    required this.position,
  });
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black54),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: widget.steps[currentStep].position.dx,
          top: widget.steps[currentStep].position.dy,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.steps[currentStep].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.steps[currentStep].description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (currentStep < widget.steps.length - 1) {
                          setState(() => currentStep++);
                        } else {
                          TutorialService.markTutorialAsShown();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        currentStep < widget.steps.length - 1
                            ? 'Next'
                            : 'Finish',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ... rest of the implementation
