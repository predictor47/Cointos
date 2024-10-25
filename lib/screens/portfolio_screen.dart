import 'package:flutter/material.dart';
import '../models/crypto_model.dart';

class PortfolioScreen extends StatefulWidget {
  final List<Crypto> portfolio;

  const PortfolioScreen({super.key, required this.portfolio});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  void _updateHoldings(int index, double amount) {
    setState(() {
      widget.portfolio[index].holdings = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
      ),
      body: ListView.builder(
        itemCount: widget.portfolio.length,
        itemBuilder: (context, index) {
          final crypto = widget.portfolio[index];
          return ListTile(
            leading: Image.network(
              crypto.image,
              width: 50,
              height: 50,
            ),
            title:
                Text(crypto.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              'Price: \$${crypto.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: GestureDetector(
              onTap: () => _showUpdateHoldingsDialog(context, index),
              child: Text(
                'Holdings: ${crypto.holdings.toStringAsFixed(4)}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement functionality to add custom crypto or update holdings
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUpdateHoldingsDialog(BuildContext context, int index) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${widget.portfolio[index].name} Holdings'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Enter amount'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              double? amount = double.tryParse(controller.text);
              if (amount != null) {
                _updateHoldings(index, amount);
              }
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
