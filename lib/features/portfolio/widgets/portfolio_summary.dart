import 'package:flutter/material.dart';
import 'package:your_app_name/core/config/app_config.dart';
import 'package:your_app_name/core/theme/app_theme.dart';

class PortfolioSummary extends StatelessWidget {
  final double totalValue;
  final double totalProfit;
  final double profitPercentage;

  const PortfolioSummary({
    Key? key,
    required this.totalValue,
    required this.totalProfit,
    required this.profitPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isProfit = totalProfit >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: AppColors.text.withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Value',
            style: TextStyle(
              color: AppColors.text.withAlpha(179),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalValue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildProfitCard(
                'Total Profit/Loss',
                totalProfit,
                isProfit,
              ),
              const SizedBox(width: 12),
              _buildProfitCard(
                '24h Change',
                profitPercentage,
                isProfit,
                isPercentage: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfitCard(String label, double value, bool isProfit,
      {bool isPercentage = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.text.withAlpha(179),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isProfit ? AppColors.success : AppColors.error,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isPercentage
                      ? '${value.abs().toStringAsFixed(2)}%'
                      : '\$${value.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isProfit ? AppColors.success : AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
