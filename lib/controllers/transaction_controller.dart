import 'package:get/get.dart';
import 'auth_controller.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../services/db_service.dart';

class TransactionController extends GetxController {
  final AuthController _authController = Get.find();
  var transactions = <TransactionModel>[].obs;
  var filteredTransactions = <TransactionModel>[].obs;
  var isLoading = false.obs;
  var monthlyStats = <String, double>{}.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to user changes to load data accordingly
    ever(_authController.user, (user) {
      if (user != null) {
        loadTransactions();
        loadMonthlyStats();
      } else {
        transactions.clear();
        filteredTransactions.clear();
        monthlyStats.clear();
      }
    });
  }

  Future<void> loadTransactions() async {
    isLoading(true);
    try {
      final userId = _authController.user.value!.id;
      if (userId == null) return;
      final transactionList = await DbService.getAllTransactions(userId);
      transactions.value = transactionList;
      filteredTransactions.value = transactionList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load transactions: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMonthlyStats() async {
    try {
      final userId = _authController.user.value!.id;
      if (userId == null) return;
      final stats = await DbService.getMonthlyStats(userId);
      monthlyStats.value = stats;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load stats: $e');
    }
  }

  Future<bool> addTransaction(TransactionModel transaction) async {
print('Adding transaction: ${transaction.title}');
    try {
      final id = await DbService.insertTransaction(transaction);
      final newTransaction = transaction.copyWith(id: id);
      transactions.add(newTransaction);
      searchTransactions(searchQuery.value);
      loadMonthlyStats();
      Get.snackbar('Success', 'Transaction added successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add transaction: $e');
      return false;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await DbService.deleteTransaction(id);
      await loadTransactions();
      await loadMonthlyStats();
      Get.snackbar('Success', 'Transaction deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete transaction: $e');
    }
  }

  void searchTransactions(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredTransactions.value = transactions;
    } else {
      filteredTransactions.value = transactions.where((transaction) {
        final titleMatch = transaction.title.toLowerCase().contains(query.toLowerCase());
        final categoryMatch = transaction.category.toLowerCase().contains(query.toLowerCase());
        return titleMatch || categoryMatch;
      }).toList();
    }
  }

  double get totalIncome {
    return transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance {
    return totalIncome - totalExpense;
  }
}