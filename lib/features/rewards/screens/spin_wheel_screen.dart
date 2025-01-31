import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/providers/rewards_provider.dart';
import '../widgets/spin_wheel.dart';
import '../models/spin_wheel_item.dart';

class SpinWheelScreen extends StatelessWidget {
  const SpinWheelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = context.watch<RewardsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Spin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Spin to win points!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 32),
            SpinWheel(
              items: const [
                SpinWheelItem(
                    label: '50 pts', value: 50, color: AppColors.success),
                SpinWheelItem(
                    label: '100 pts', value: 100, color: AppColors.info),
                SpinWheelItem(
                    label: '150 pts', value: 150, color: AppColors.warning),
                SpinWheelItem(
                    label: '200 pts', value: 200, color: AppColors.error),
                SpinWheelItem(
                    label: '500 pts', value: 500, color: AppColors.accent),
                SpinWheelItem(
                    label: '1000 pts', value: 1000, color: AppColors.primary),
              ],
              onSpinComplete: (points) async {
                await rewards.addPoints(points, 'Spin Wheel');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You won $points points!')),
                  );
                  Navigator.pop(context);
                }
              },
              onSpinEnd: () {},
            ),
          ],
        ),
      ),
    );
  }
}
