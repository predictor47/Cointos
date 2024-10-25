import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:math';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _points = 1000; // Replace with actual point value from your data source
  bool _canSpin = true;
  final List<int> _rewards = [50, 100, 150, 200, 250, 300];

  @override
  void initState() {
    super.initState();
    _checkSpinEligibility();
  }

  Future<void> _checkSpinEligibility() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSpinTime = prefs.getInt('lastSpinTime') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _canSpin = currentTime - lastSpinTime >= 24 * 60 * 60 * 1000; // 24 hours
    });
  }

  Future<void> _spinWheel() async {
    if (_canSpin) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('lastSpinTime', DateTime.now().millisecondsSinceEpoch);

      final reward = _rewards[Random().nextInt(_rewards.length)];
      setState(() {
        _points += reward;
        _canSpin = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You won $reward points!')),
      );

      // Update points in your data source here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only spin once a day.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.card_giftcard,
                  color: Theme.of(context).primaryColor),
              title: const Text('Available Points'),
              subtitle: Text('$_points'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: FortuneWheel(
              selected: Stream.value(0),
              items: [
                for (var reward in _rewards)
                  FortuneItem(child: Text('$reward')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _canSpin ? _spinWheel : null,
            child: Text(_canSpin ? 'Spin the Wheel' : 'Come back tomorrow'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Available Rewards',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // List of rewards
          RewardItem(
            title: 'Free Coffee',
            points: 500,
            onRedeem: () {
              // Handle redemption
            },
          ),
          RewardItem(
            title: '10% Discount',
            points: 1000,
            onRedeem: () {
              // Handle redemption
            },
          ),
          // Add more RewardItems as needed
        ],
      ),
    );
  }
}

class RewardItem extends StatelessWidget {
  final String title;
  final int points;
  final VoidCallback onRedeem;

  const RewardItem({
    super.key,
    required this.title,
    required this.points,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$points points'),
        trailing: ElevatedButton(
          onPressed: onRedeem,
          child: const Text('Redeem'),
        ),
      ),
    );
  }
}
