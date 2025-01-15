import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:your_app_name/core/di/service_locator.dart';
import 'package:your_app_name/core/theme/app_theme.dart';
import 'package:your_app_name/data/repositories/user_repository.dart';
import 'package:your_app_name/features/auth/screens/login_screen.dart';
import 'package:your_app_name/features/home/screens/home_screen.dart';
import 'package:your_app_name/features/portfolio/screens/portfolio_screen.dart';
import 'package:your_app_name/features/profile/screens/profile_screen.dart';
import 'package:your_app_name/features/rewards/screens/rewards_screen.dart';
import 'package:your_app_name/providers/portfolio_provider.dart';
import 'package:your_app_name/providers/rewards_provider.dart';
import 'package:your_app_name/services/analytics_service.dart';
import 'package:your_app_name/services/notification_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = const [
    HomeScreen(),
    PortfolioScreen(),
    RewardsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Initialize necessary services
    final analytics = getIt<AnalyticsService>();
    final notifications = getIt<NotificationService>();

    // Request notification permissions if not already granted
    await notifications.initialize();

    // Log screen view
    await analytics.logScreenView(
      screenName: 'main_screen',
      screenClass: 'MainScreen',
    );

    // Fetch initial data
    if (mounted) {
      context.read<PortfolioProvider>().fetchPortfolio();
      context.read<RewardsProvider>().fetchRewards();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _onDestinationSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to user authentication state
    final user = context.watch<auth.User?>();
    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'View market overview',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
            tooltip: 'Manage your portfolio',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(
                context.watch<RewardsProvider>().availableRewards.toString(),
              ),
              isLabelVisible:
                  context.watch<RewardsProvider>().hasAvailableRewards,
              child: const Icon(Icons.stars_outlined),
            ),
            selectedIcon: Badge(
              label: Text(
                context.watch<RewardsProvider>().availableRewards.toString(),
              ),
              isLabelVisible:
                  context.watch<RewardsProvider>().hasAvailableRewards,
              child: const Icon(Icons.stars),
            ),
            label: 'Rewards',
            tooltip: 'View available rewards',
          ),
          NavigationDestination(
            icon: Stack(
              children: [
                const Icon(Icons.person_outline),
                if (context.watch<UserRepository>().hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            selectedIcon: Stack(
              children: [
                const Icon(Icons.person),
                if (context.watch<UserRepository>().hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Profile',
            tooltip: 'View profile settings',
          ),
        ],
      ),
    );
  }
}
