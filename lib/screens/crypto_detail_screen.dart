import 'package:flutter/material.dart';
import 'package:myapp/services/crypto_service.dart';
import '../models/crypto_model.dart';
import '../screens/crypto_detail_screen.dart';
import '../screens/crypto_chart.dart';

class CryptoDetailScreen extends StatefulWidget {
  final Crypto crypto;

  const CryptoDetailScreen({super.key, required this.crypto});

  @override
  _CryptoDetailScreenState createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  late Future<List<double>> _historicalData;

  @override
  void initState() {
    super.initState();
    _historicalData = CryptoService()
        .fetchHistoricalData(widget.crypto.id, 3); // Fetch 7 days of data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crypto.name),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.crypto.image,
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.crypto.name,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Symbol: ${widget.crypto.symbol.toUpperCase()}',
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              'Current Price: \$${widget.crypto.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<double>>(
              future: _historicalData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No data available',
                          style: TextStyle(color: Colors.white)));
                } else {
                  return SizedBox(
                    height:
                        300, // Adjust height to make sure the chart is clearly visible
                    child: CryptoBarChart(prices: snapshot.data!),
                  );
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1e1e1e),
    );
  }
}
