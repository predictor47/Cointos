import 'package:flutter/material.dart';
import 'package:kointos/core/config/app_config.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/models/crypto_model.dart';
import 'package:shimmer/shimmer.dart';

class TopCoinsSlider extends StatelessWidget {
  final List<Crypto> coins;
  final bool isLoading;

  const TopCoinsSlider({
    super.key,
    required this.coins,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => const _TopCoinShimmer(),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coins.take(3).length,
        itemBuilder: (context, index) => _TopCoinCard(coin: coins[index]),
      ),
    );
  }
}

class _TopCoinCard extends StatelessWidget {
  final Crypto coin;

  const _TopCoinCard({required this.coin});

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.priceChangePercentage24h >= 0;

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(
          color: AppColors.text.withAlpha(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                coin.image,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                coin.symbol.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '\$${coin.currentPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? AppColors.success : AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: isPositive ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopCoinShimmer extends StatelessWidget {
  const _TopCoinShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.text.withAlpha(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.text,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            Container(
              width: 100,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.text,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.text,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
