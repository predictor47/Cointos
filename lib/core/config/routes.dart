class AppRoutes {
  static const String home = '/';
  static const String portfolio = '/portfolio';
  static const String rewards = '/rewards';
  static const String cryptoDetail = '/crypto/:id';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case portfolio:
        return MaterialPageRoute(builder: (_) => const PortfolioScreen());
      // Add other routes
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
} 