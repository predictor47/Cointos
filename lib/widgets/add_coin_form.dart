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
            Text(
              'Add Coin to Portfolio',
              style: TextStyle(
                color: UpgradedAppTheme.textColor,
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
                labelStyle: TextStyle(color: UpgradedAppTheme.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: UpgradedAppTheme.textColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: UpgradedAppTheme.accentColor),
                ),
              ),
              style: TextStyle(color: UpgradedAppTheme.textColor),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                backgroundColor: UpgradedAppTheme.accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
        final currentPrice = await CryptoService().getCurrentPrice(selectedCoinId!);
        
        final portfolio = Provider.of<PortfolioProvider>(context, listen: false);
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