import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/transaction_model.dart';
import '../controllers/transaction_controller.dart';
import '../utils/category_icons.dart';
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTile({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.type == 'income' ? Colors.green : Colors.red,
          child: Icon(
            transaction.type == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  categoryIcons[transaction.category] ?? Icons.category,
                  size: 16,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(transaction.category),
              ],
            ),
            Text(
              '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.type == 'income' ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TransactionController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Transaction'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                controller.deleteTransaction(transaction.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}