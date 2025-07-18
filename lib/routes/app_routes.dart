import 'package:get/get.dart';
import '../screens/main_screen.dart';
import '../screens/add_transaction.dart';
import '../screens/stats_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String addTransaction = '/add-transaction';
  static const String stats = '/stats';
  static const String login = '/login';
  static const String register = '/register';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => MainScreen(),
    ),
    GetPage(
      name: addTransaction,
      page: () => AddTransactionScreen(),
    ),
    GetPage(
      name: stats,
      page: () => StatsScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
    ),
  ];
}