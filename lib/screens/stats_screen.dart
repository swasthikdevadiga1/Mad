import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/pie_chart.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();
    final expenseCategories = [
      'Food', 'Transportation', 'Entertainment', 'Shopping', 'Bills',
      'Health', 'Education', 'Other'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('This Month'),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildStatCard(
                  'Income',
                  controller.monthlyStats['income'] ?? 0.0,
                  Colors.green,
                  Icons.arrow_upward,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  'Expense',
                  controller.monthlyStats['expense'] ?? 0.0,
                  Colors.red,
                  Icons.arrow_downward,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  'Balance',
                  (controller.monthlyStats['income'] ?? 0.0) -
                      (controller.monthlyStats['expense'] ?? 0.0),
                  Colors.blue,
                  Icons.account_balance_wallet,
                ),
              ],
            )),
            const SizedBox(height: 32),
            _buildSectionTitle('Expense Breakdown'),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final monthlyExpenses = controller.transactions.where((t) {
                final now = DateTime.now();
                return t.type == 'expense' &&
                    t.date.month == now.month &&
                    t.date.year == now.year;
              }).toList();
              return SimplePieChart(
                expenses: monthlyExpenses,
                categories: expenseCategories,
              );
            }),
            const SizedBox(height: 32),
            _buildSectionTitle('Overall Statistics'),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildStatCard(
                  'Total Income',
                  controller.totalIncome,
                  Colors.green,
                  Icons.trending_up,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  'Total Expense',
                  controller.totalExpense,
                  Colors.red,
                  Icons.trending_down,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  'Net Balance',
                  controller.balance,
                  controller.balance >= 0 ? Colors.green : Colors.red,
                  Icons.account_balance,
                ),
              ],
            )),
            const SizedBox(height: 32),
            _buildSectionTitle('Transaction Count'),
            const SizedBox(height: 16),
            Obx(() => _buildStatCard(
              'Total Transactions',
              controller.transactions.length.toDouble(),
              Colors.purple,
              Icons.receipt_long,
              showCurrency: false,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatCard(String title, double value, Color color, IconData icon,
      {bool showCurrency = true}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    showCurrency
                        ? '₹${value.toStringAsFixed(2)}'
                        : value.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}