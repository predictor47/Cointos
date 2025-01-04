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
        .fetchHistoricalData(widget.crypto.id, 7); // Increased to 7 days
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crypto.name),
        backgroundColor: UpgradedAppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildPriceSection(),
              const SizedBox(height: 24),
              _buildChartSection(),
              const SizedBox(height: 24),
              _buildStatsSection(),
            ],
          ),
        ),
      ),
      backgroundColor: UpgradedAppTheme.backgroundColor,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: UpgradedAppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(
            widget.crypto.image,
            width: 60,
            height: 60,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.crypto.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: UpgradedAppTheme.textColor,
                ),
              ),
              Text(
                widget.crypto.symbol.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: UpgradedAppTheme.textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    final priceChange = widget.crypto.priceChangePercentage24h;
    final isPositive = priceChange >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UpgradedAppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$${widget.crypto.currentPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: UpgradedAppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
              Text(
                '${priceChange.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 16,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UpgradedAppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7-Day Price History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: UpgradedAppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: FutureBuilder<List<double>>(
              future: _historicalData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: UpgradedAppTheme.textColor),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: UpgradedAppTheme.textColor),
                    ),
                  );
                } else {
                  return CryptoLineChart(prices: snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UpgradedAppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: UpgradedAppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Market Cap', '\$${widget.crypto.marketCap.toStringAsFixed(2)}'),
          _buildStatRow('24h High', '\$${widget.crypto.high24h.toStringAsFixed(2)}'),
          _buildStatRow('24h Low', '\$${widget.crypto.low24h.toStringAsFixed(2)}'),
          _buildStatRow('Volume', '\$${widget.crypto.totalVolume.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: UpgradedAppTheme.textColor.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: UpgradedAppTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
