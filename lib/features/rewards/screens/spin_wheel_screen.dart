class SpinWheelScreen extends StatelessWidget {
  final List<SpinWheelItem> wheelItems = const [
    SpinWheelItem(points: 10, color: Colors.red),
    SpinWheelItem(points: 20, color: Colors.blue),
    SpinWheelItem(points: 30, color: Colors.green),
    SpinWheelItem(points: 40, color: Colors.yellow),
    SpinWheelItem(points: 50, color: Colors.purple),
    SpinWheelItem(points: 100, color: Colors.orange),
  ];

  const SpinWheelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin & Win'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinWheel(
              items: wheelItems,
              onSpinEnd: (item) async {
                final rewards = context.read<RewardsProvider>();
                await rewards.addPoints(item.points, 'Daily Spin');
                
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Congratulations!'),
                      content: Text('You won ${item.points} points!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Return to rewards screen
                          },
                          child: const Text('Claim'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Spin the wheel to win points!',
              style: TextStyle(
                color: AppColors.text.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 