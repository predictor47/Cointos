import 'package:flutter/material.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/services/tutorial_service.dart';

class TutorialStep {
  final String title;
  final String description;
  final Offset position;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.position,
  });
}

class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;

  const TutorialOverlay({super.key, required this.steps});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Container(color: Colors.black54),

        // Tutorial content
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: widget.steps[currentStep].position.dx,
          top: widget.steps[currentStep].position.dy,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withAlpha(77),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.steps[currentStep].title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.steps[currentStep].description,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                  ),
                ),
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
                        style: const TextStyle(color: AppColors.accent),
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
