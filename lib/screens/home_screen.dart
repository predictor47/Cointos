import 'package:flutter/material.dart';
import '../services/crypto_service.dart';
import 'crypto_detail_screen.dart';
import '../models/crypto_model.dart';
import 'account_screen.dart';
import 'portfolio_screen.dart';
import 'news_screen.dart';
import 'package:logger/logger.dart';
import 'rewards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Crypto> _favorites = [];
  final List<Crypto> _watchlist = [];
  final List<Crypto> _portfolio = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToFavorites(Crypto crypto) {
    setState(() {
      _favorites.add(crypto);
    });
  }

  void _addToWatchlist(Crypto crypto) {
    setState(() {
      _watchlist.add(crypto);
    });
  }

  void _addToPortfolio(Crypto crypto) {
    setState(() {
      _portfolio.add(crypto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptotos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CryptoListScreen(
            onAddFavorite: _addToFavorites,
            onAddWatchlist: _addToWatchlist,
            onAddPortfolio: _addToPortfolio,
          ),
          PortfolioScreen(portfolio: _portfolio),
          const NewsScreen(),
          FavoritesScreen(favorites: _favorites),
          const RewardsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Cryptos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  final Function(Crypto) onAddFavorite;
  final Function(Crypto) onAddWatchlist;
  final Function(Crypto) onAddPortfolio;

  const CryptoListScreen({
    super.key,
    required this.onAddFavorite,
    required this.onAddWatchlist,
    required this.onAddPortfolio,
  });

  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final Logger _logger = Logger();
  late Future<List<Crypto>> _cryptoList;
  List<Crypto> _filteredCryptos = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCryptos();
  }

  Future<void> _fetchCryptos() async {
    try {
      _cryptoList = CryptoService().fetchCryptos();
      final cryptos = await _cryptoList;
      setState(() {
        _filteredCryptos = cryptos;
      });
    } catch (e) {
      _logger.e('Error fetching cryptos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to load cryptocurrencies. Please try again later.'),
        ),
      );
    }
  }

  void _filterCryptos(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredCryptos = [];
      } else {
        _filteredCryptos = _filteredCryptos
            .where((crypto) =>
                crypto.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'Cryptotos',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    onChanged: _filterCryptos,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<List<Crypto>>(
                future: _cryptoList,
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
                    final List<Crypto> displayedCryptos = _searchQuery.isEmpty
                        ? snapshot.data!
                        : _filteredCryptos;

                    return RefreshIndicator(
                      onRefresh: _fetchCryptos,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        itemCount: displayedCryptos.length,
                        itemBuilder: (context, index) {
                          final crypto = displayedCryptos[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Image.network(
                                crypto.image,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(crypto.name,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                'Price: \$${crypto.currentPrice.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              tileColor: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CryptoDetailScreen(crypto: crypto),
                                  ),
                                );
                              },
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'favorite') {
                                    widget.onAddFavorite(crypto);
                                  } else if (value == 'watchlist') {
                                    widget.onAddWatchlist(crypto);
                                  } else if (value == 'portfolio') {
                                    widget.onAddPortfolio(crypto);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'favorite',
                                    child: Text('Add to Favorites'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'watchlist',
                                    child: Text('Add to Watchlist'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'portfolio',
                                    child: Text('Add to Portfolio'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Crypto> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final crypto = favorites[index];
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
          );
        },
      ),
    );
  }
}

class WatchlistScreen extends StatelessWidget {
  final List<Crypto> watchlist;

  const WatchlistScreen({super.key, required this.watchlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: watchlist.length,
        itemBuilder: (context, index) {
          final crypto = watchlist[index];
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
          );
        },
      ),
    );
  }
}
