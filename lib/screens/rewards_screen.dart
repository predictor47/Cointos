import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import '../services/user_service.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final UserService _userService = UserService();
  bool _canSpin = false;

  @override
  void initState() {
    super.initState();
    _checkSpinEligibility();
  }

  void _checkSpinEligibility() async {
    final canSpin = await _userService.canSpinWheel();
    setState(() {
      _canSpin = canSpin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FortuneWheel(
              selected: Stream.value(0),
              items: [
                for (int i = 1; i <= 8; i++)
                  FortuneItem(child: Text('${i * 10} points')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _canSpin ? _spinWheel : null,
              child: const Text('Spin the Wheel'),
            ),
          ],
        ),
      ),
    );
  }

  void _spinWheel() async {
    try {
      final points = await _userService.spinWheel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You won $points points!')),
      );
    } catch (e) {
      print('Error spinning wheel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to spin the wheel. Please try again later.')),
      );
    }
    _checkSpinEligibility();
  }
}
