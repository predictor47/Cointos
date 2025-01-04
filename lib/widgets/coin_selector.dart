class CoinSelector extends StatefulWidget {
  final void Function(String) onCoinSelected;

  const CoinSelector({Key? key, required this.onCoinSelected}) : super(key: key);

  @override
  State<CoinSelector> createState() => _CoinSelectorState();
}

class _CoinSelectorState extends State<CoinSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Crypto> _searchResults = [];
  Timer? _debounceTimer;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _searchCoins(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final results = await CryptoService().searchCoins(query);
      setState(() => _searchResults = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching coins: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _debounceSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchCoins(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _searchController,
          style: TextStyle(color: UpgradedAppTheme.textColor),
          decoration: InputDecoration(
            hintText: 'Search coins...',
            hintStyle: TextStyle(color: UpgradedAppTheme.textColor.withOpacity(0.5)),
            prefixIcon: Icon(Icons.search, color: UpgradedAppTheme.textColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: UpgradedAppTheme.textColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: UpgradedAppTheme.textColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: UpgradedAppTheme.accentColor),
            ),
          ),
          onChanged: _debounceSearch,
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          )
        else if (_searchResults.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: UpgradedAppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final coin = _searchResults[index];
                return ListTile(
                  leading: Image.network(
                    coin.image,
                    width: 24,
                    height: 24,
                  ),
                  title: Text(
                    coin.name,
                    style: TextStyle(color: UpgradedAppTheme.textColor),
                  ),
                  subtitle: Text(
                    coin.symbol.toUpperCase(),
                    style: TextStyle(
                      color: UpgradedAppTheme.textColor.withOpacity(0.7),
                    ),
                  ),
                  onTap: () {
                    widget.onCoinSelected(coin.id);
                    _searchController.clear();
                    setState(() => _searchResults = []);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
} 