class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PortfolioProvider>(
      builder: (context, portfolio, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Portfolio'),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.portfolioAnalytics,
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => portfolio.updatePrices(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      children: [
                        PortfolioSummary(
                          totalValue: portfolio.totalValue,
                          totalProfit: portfolio.totalProfit,
                          profitPercentage: portfolio.profitPercentage24h,
                        ),
                        const SizedBox(height: 24),
                        if (portfolio.portfolio.isEmpty)
                          _buildEmptyState()
                        else
                          _buildPortfolioChart(portfolio),
                      ],
                    ),
                  ),
                ),
                if (portfolio.portfolio.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = portfolio.portfolio.values.elementAt(index);
                        final coin = portfolio.coins[item.coinId]!;
                        return PortfolioCoinCard(
                          item: item,
                          coin: coin,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.cryptoDetail,
                            arguments: coin,
                          ),
                          onEdit: () => _showEditDialog(item),
                          onDelete: () => _showDeleteDialog(item),
                        );
                      },
                      childCount: portfolio.portfolio.length,
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddCoinDialog,
            child: const Icon(Icons.add),
            backgroundColor: AppColors.accent,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: AppColors.text.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Your portfolio is empty',
            style: TextStyle(
              color: AppColors.text.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add Coin',
            onPressed: _showAddCoinDialog,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioChart(PortfolioProvider portfolio) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
      ),
      child: const CryptoLineChart(
        prices: [], // TODO: Implement portfolio historical data
        showLabels: true,
      ),
    );
  }

  void _showAddCoinDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCoinForm(),
    );
  }

  void _showEditDialog(PortfolioItem item) {
    // TODO: Implement edit dialog
  }

  void _showDeleteDialog(PortfolioItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Coin'),
        content: const Text('Are you sure you want to delete this coin from your portfolio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PortfolioProvider>().removeCoin(item.coinId);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
} 