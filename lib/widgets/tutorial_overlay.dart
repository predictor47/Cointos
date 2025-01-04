class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;

  const TutorialOverlay({Key? key, required this.steps}) : super(key: key);

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
              color: UpgradedAppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: UpgradedAppTheme.accentColor.withOpacity(0.3),
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
                  style: TextStyle(
                    color: UpgradedAppTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.steps[currentStep].description,
                  style: TextStyle(
                    color: UpgradedAppTheme.textColor.withOpacity(0.8),
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
                        currentStep < widget.steps.length - 1 ? 'Next' : 'Finish',
                        style: TextStyle(color: UpgradedAppTheme.accentColor),
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