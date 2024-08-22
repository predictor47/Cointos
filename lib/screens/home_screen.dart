import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/coin_service.dart';
import '../models/coin_model.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CoinService _coinService = CoinService();
  List<Coin> _topCoins = [];
  List<Coin> _allCoins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoinData();
  }

  Future<void> _fetchCoinData() async {
    try {
      final topCoins = await _coinService.getTopCoins(limit: 5);
      final allCoins = await _coinService.getAllCoins();
      setState(() {
        _topCoins = topCoins;
        _allCoins = allCoins;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching coin data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Color(0xFF161B22),
        title: Text('Cointos Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchCoinData,
          ),
        ],
      ),
      drawer: _buildSidebar(context, authProvider),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
          : _buildHomeContent(),
    );
  }

  Widget _buildSidebar(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: Container(
        color: Color(0xFF161B22),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0D9488)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFF0D9488)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    authProvider.user?.email ?? 'User',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Sign Out', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await authProvider.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Top Coins',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _topCoins.length,
              itemBuilder: (context, index) {
                return _buildTopCoinCard(_topCoins[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'All Coins',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _allCoins.length,
            itemBuilder: (context, index) {
              return _buildCoinListItem(_allCoins[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopCoinCard(Coin coin) {
    return Card(
      color: Color(0xFF161B22),
      margin: EdgeInsets.all(8),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coin.name,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${coin.currentPrice.toStringAsFixed(2)}',
              style: TextStyle(color: Color(0xFF0D9488), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _buildMiniChart(coin.sparklineIn7d),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinListItem(Coin coin) {
    return ListTile(
      title: Text(coin.name, style: TextStyle(color: Colors.white)),
      subtitle: Text(coin.symbol.toUpperCase(), style: TextStyle(color: Colors.grey)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${coin.currentPrice.toStringAsFixed(2)}',
            style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            width: 60,
            height: 30,
            child: _buildMiniChart(coin.sparklineIn7d),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChart(List<double> data) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: data.reduce((a, b) => a < b ? a : b),
        maxY: data.reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: Color(0xFF0D9488),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}