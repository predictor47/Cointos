import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../core/di/service_locator.dart';
import '../core/theme/app_theme.dart';
import '../data/repositories/user_repository.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/portfolio/screens/portfolio_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/rewards/screens/rewards_screen.dart';
import '../providers/portfolio_provider.dart';
import '../providers/rewards_provider.dart';
import '../services/analytics_service.dart';
import '../services/notification_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

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
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: AppColors.surface,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.account_balance_wallet), label: 'Portfolio'),
          NavigationDestination(icon: Icon(Icons.stars), label: 'Rewards'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Market'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
