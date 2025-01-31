import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kointos/core/config/app_config.dart';
import 'package:kointos/core/config/routes.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/providers/rewards_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RewardsProvider>(
      builder: (context, rewards, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Rewards'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPointsCard(rewards.totalPoints),
                const SizedBox(height: 24),
                _buildDailySpinCard(context, rewards),
                const SizedBox(height: 24),
                _buildRewardHistory(rewards),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPointsCard(int points) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        gradient: LinearGradient(
          colors: [
            AppColors.accent,
            AppColors.accent.withAlpha(179), // 0.7 opacity
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Points',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            points.toString(),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySpinCard(BuildContext context, RewardsProvider rewards) {
    return Card(
      child: InkWell(
        onTap: () async {
          if (await rewards.canSpin()) {
            Navigator.pushNamed(context, AppRoutes.spinWheel);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Daily spin limit reached')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withAlpha(26), // 0.1 opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.casino,
                  color: AppColors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Spin',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Spin the wheel to earn points',
                      style: TextStyle(
                        color: AppColors.text.withAlpha(179), // 0.7 opacity
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardHistory(RewardsProvider rewards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reward History',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: rewards.getRewardHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No rewards yet',
                  style: TextStyle(
                    color: AppColors.text.withAlpha(179), // 0.7 opacity
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reward = snapshot.data![index];
                return ListTile(
                  leading: Icon(
                    _getRewardIcon(reward['source']),
                    color: AppColors.accent,
                  ),
                  title: Text(
                    reward['source'],
                    style: const TextStyle(color: AppColors.text),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(reward['timestamp']),
                    style: TextStyle(
                        color: AppColors.text.withAlpha(179)), // 0.7 opacity
                  ),
                  trailing: Text(
                    '+${reward['points']}',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  IconData _getRewardIcon(String source) {
    if (source.contains('Spin')) return Icons.casino;
    if (source.contains('Article')) return Icons.article;
    return Icons.stars;
  }
}
