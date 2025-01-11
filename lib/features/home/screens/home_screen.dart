import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app_name/core/config/app_config.dart';
import 'package:your_app_name/core/config/routes.dart';
import 'package:your_app_name/core/di/service_locator.dart';
import 'package:your_app_name/core/utils/error_handler.dart';
import 'package:your_app_name/services/crypto_service.dart';
import '../widgets/category_filter.dart';
import '../widgets/top_coins_slider.dart';
import '../widgets/coin_list_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:your_app_name/models/crypto_model.dart';
import 'package:your_app_name/core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cryptoService = getIt<CryptoService>();
  final _refreshController = RefreshController();
  String _selectedCategory = 'All';
  List<Crypto> _coins = [];
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: AppConfig.priceUpdateInterval),
      (_) => _loadData(),
    );
  }

  Future<void> _loadData() async {
    try {
      final coins = await _cryptoService.getTopCoins();
      if (mounted) {
        setState(() {
          _coins = coins;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getMessage(e))),
        );
      }
    }
  }

  List<Crypto> _getFilteredCoins() {
    if (_selectedCategory == 'All') return _coins;
    return _coins.where((coin) => coin.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await _loadData();
          _refreshController.refreshCompleted();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopCoinsSlider(
                      coins: _coins.take(3).toList(),
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),
                    CategoryFilter(
                      categories: const ['All', 'DeFi', 'NFT', 'Layer 1', 'Layer 2'],
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'All Coins',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final coin = _getFilteredCoins()[index];
                    return CoinListTile(
                      coin: coin,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.cryptoDetail,
                        arguments: coin,
                      ),
                    );
                  },
                  childCount: _getFilteredCoins().length,
                ),
              ),
          ],
        ),
      ),
    );
  }
} 