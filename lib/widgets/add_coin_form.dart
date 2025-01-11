import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app_name/core/theme/app_theme.dart';
import 'package:your_app_name/providers/portfolio_provider.dart';
import 'package:your_app_name/services/crypto_service.dart';
import 'package:your_app_name/widgets/coin_selector.dart';

class AddCoinForm extends StatefulWidget {
  const AddCoinForm({super.key});

  @override
  State<AddCoinForm> createState() => _AddCoinFormState();
}

class _AddCoinFormState extends State<AddCoinForm> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCoinId;
  String? selectedCoinName;
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Coin to Portfolio',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CoinSelector(
              onCoinSelected: (coinId) {
                setState(() => selectedCoinId = coinId);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: const TextStyle(color: AppColors.text),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.text.withAlpha(77),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: const TextStyle(color: AppColors.text),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Add to Portfolio'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedCoinId != null) {
      try {
        final amount = double.parse(_amountController.text);
        final currentPrice =
            await CryptoService().getCurrentPrice(selectedCoinId!);

        final portfolio =
            Provider.of<PortfolioProvider>(context, listen: false);
        await portfolio.addCoin(selectedCoinId!, amount, currentPrice);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coin added to portfolio')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
