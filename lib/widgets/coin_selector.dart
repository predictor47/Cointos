import 'package:flutter/material.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/models/crypto_model.dart';
import 'package:kointos/services/crypto_service.dart';

class CoinSelector extends StatelessWidget {
  final ValueChanged<String?> onCoinSelected;

  const CoinSelector({super.key, required this.onCoinSelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Crypto>>(
      future: CryptoService().getTopCoins(),
      builder: (context, snapshot) {
        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Coin',
            labelStyle: TextStyle(color: AppColors.text),
          ),
          items: snapshot.data
                  ?.map((coin) => DropdownMenuItem(
                        value: coin.id,
                        child: Text(coin.name,
                            style: const TextStyle(color: AppColors.text)),
                      ))
                  .toList() ??
              [],
          onChanged: onCoinSelected,
        );
      },
    );
  }
}
