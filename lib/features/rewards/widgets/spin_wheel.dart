class SpinWheel extends StatefulWidget {
  final List<SpinWheelItem> items;
  final Function(SpinWheelItem) onSpinEnd;

  const SpinWheel({
    Key? key,
    required this.items,
    required this.onSpinEnd,
  }) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final StreamController<int> _selectedIndexController = StreamController<int>();
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isSpinning = false;
        final selectedIndex = _calculateSelectedIndex(_animation.value);
        widget.onSpinEnd(widget.items[selectedIndex]);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectedIndexController.close();
    super.dispose();
  }

  void spin() {
    if (_isSpinning) return;

    _isSpinning = true;
    final random = Random();
    final spinCount = 5 + random.nextInt(5); // 5-10 full rotations
    final extraAngle = random.nextDouble() * 360.0;
    final endAngle = spinCount * 360.0 + extraAngle;

    _animation = Tween<double>(
      begin: 0,
      end: endAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _animation.addListener(() {
      final currentIndex = _calculateSelectedIndex(_animation.value);
      _selectedIndexController.add(currentIndex);
    });

    _controller.forward(from: 0);
  }

  int _calculateSelectedIndex(double angle) {
    final normalized = angle % 360;
    final itemAngle = 360.0 / widget.items.length;
    return (normalized / itemAngle).floor() % widget.items.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              StreamBuilder<int>(
                stream: _selectedIndexController.stream,
                builder: (context, snapshot) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: (_animation.value) * (pi / 180),
                        child: CustomPaint(
                          size: const Size(300, 300),
                          painter: WheelPainter(
                            items: widget.items,
                            selectedIndex: snapshot.data ?? 0,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // Center pointer
              const Icon(
                Icons.arrow_downward,
                size: 40,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'SPIN',
          onPressed: _isSpinning ? null : spin,
          width: 200,
          backgroundColor: AppColors.accent,
          isLoading: _isSpinning,
        ),
      ],
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<SpinWheelItem> items;
  final int selectedIndex;

  WheelPainter({
    required this.items,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final itemAngle = 2 * pi / items.length;

    for (var i = 0; i < items.length; i++) {
      final startAngle = i * itemAngle;
      final paint = Paint()
        ..color = i == selectedIndex
            ? items[i].color.withOpacity(0.8)
            : items[i].color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        itemAngle,
        true,
        paint,
      );

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${items[i].points}',
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final textAngle = startAngle + (itemAngle / 2);
      final textRadius = radius * 0.7;
      final x = center.dx + textRadius * cos(textAngle);
      final y = center.dy + textRadius * sin(textAngle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(textAngle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SpinWheelItem {
  final int points;
  final Color color;

  const SpinWheelItem({
    required this.points,
    required this.color,
  });
} 