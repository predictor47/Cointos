import 'package:flutter/material.dart';
import 'package:your_app_name/core/config/app_config.dart';
import 'package:your_app_name/core/theme/app_theme.dart';
import 'package:your_app_name/models/crypto_model.dart';
import 'package:your_app_name/models/portfolio_item.dart';

class PortfolioCoinCard extends StatelessWidget {
  final PortfolioItem item;
  final Crypto coin;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PortfolioCoinCard({
    super.key,
    required this.item,
    required this.coin,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue = item.getCurrentValue(coin.currentPrice);
    final profitLoss = item.getProfitLoss(coin.currentPrice);
    final profitLossPercentage =
        item.getProfitLossPercentage(coin.currentPrice);
    final isProfit = profitLoss >= 0;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConfig.defaultPadding,
        vertical: 8,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    coin.image,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${item.amount} ${coin.symbol.toUpperCase()}',
                          style: TextStyle(
                            color: AppColors.text.withAlpha(179),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.text.withAlpha(179),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Value',
                        style: TextStyle(
                          color: AppColors.text.withAlpha(179),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${currentValue.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Profit/Loss',
                        style: TextStyle(
                          color: AppColors.text.withAlpha(179),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isProfit
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color:
                                isProfit ? AppColors.success : AppColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${profitLossPercentage.abs().toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: isProfit
                                  ? AppColors.success
                                  : AppColors.error,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
