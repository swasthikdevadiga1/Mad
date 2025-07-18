import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/transaction_tile.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Hi, ${authController.user.value?.name ?? ''}')),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${transactionController.balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIncomeExpense(
                        'Income',
                        '₹${transactionController.totalIncome.toStringAsFixed(2)}',
                        Icons.arrow_upward,
                        Colors.greenAccent,
                      ),
                      _buildIncomeExpense(
                        'Expense',
                        '₹${transactionController.totalExpense.toStringAsFixed(2)}',
                        Icons.arrow_downward,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              )),
            ),
            const SizedBox(height: 24),
            // Search Bar
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => transactionController.searchTransactions(value),
            ),
            const SizedBox(height: 16),
            // Transactions List
            Expanded(
              child: Obx(() {
                if (transactionController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (transactionController.filteredTransactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: transactionController.filteredTransactions.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(
                      transaction: transactionController.filteredTransactions[index],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpense(String title, String amount, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}