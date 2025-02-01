import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/config/app_config.dart';
import '/core/config/routes.dart';
import '/core/di/service_locator.dart';
import '/core/utils/error_handler.dart';
import '/services/crypto_service.dart';
import 'package:kointos/features/home/widgets/category_filter.dart';
import 'package:kointos/features/home/widgets/top_coins_slider.dart';
import 'package:kointos/features/home/widgets/coin_list_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/models/crypto_model.dart';
import '/core/theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  Future<void> _fetchCoins() async {
    setState(() => _isLoading = true);
    try {
      _coins = await _cryptoService.getTopCoins();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getMessage(e))),
        );
      }
    } finally {
      setState(() => _isLoading = false);
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
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _fetchCoins,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Home'),
              floating: true,
            ),
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
                      categories: const [
                        'All',
                        'DeFi',
                        'NFT',
                        'Layer 1',
                        'Layer 2'
                      ],
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
