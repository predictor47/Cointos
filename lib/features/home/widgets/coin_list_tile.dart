import 'package:flutter/material.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/models/crypto_model.dart';

class CoinListTile extends StatelessWidget {
  final Crypto coin;
  final VoidCallback onTap;

  const CoinListTile({
    super.key,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.priceChangePercentage24h >= 0;

    return ListTile(
      onTap: onTap,
      leading: Image.network(
        coin.image,
        width: 32,
        height: 32,
      ),
      title: Text(
        coin.name,
        style: const TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        coin.symbol.toUpperCase(),
        style: TextStyle(
          color: AppColors.text.withAlpha(179),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${coin.currentPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
            style: TextStyle(
              color: isPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
