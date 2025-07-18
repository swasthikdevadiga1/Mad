import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class SimplePieChart extends StatelessWidget {
  final List<TransactionModel> expenses;
  final List<String> categories;

  const SimplePieChart({
    Key? key,
    required this.expenses,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total amount
    final total = expenses.fold(0.0, (sum, t) => sum + t.amount);
    
    if (total == 0) {
      return Center(
        child: Text('No expenses to display'),
      );
    }

    // Calculate amounts by category
    final categoryAmounts = categories.map((category) {
      final amount = expenses
          .where((t) => t.category == category)
          .fold(0.0, (sum, t) => sum + t.amount);
      return {
        'category': category,
        'amount': amount,
        'percentage': (amount / total) * 100,
      };
    }).toList();

    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pie chart segments
                CustomPaint(
                  size: Size(200, 200),
                  painter: PieChartPainter(categoryAmounts),
                ),
                // Center text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Legend
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categoryAmounts.map((item) {
              final colors = _getColors();
              final colorIndex = categories.indexOf(item['category'] as String) % colors.length;
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: colors[colorIndex],
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${item['category']}: ₹${(item['amount'] as double? ?? 0.0).toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<Color> _getColors() {
    return [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
    ];
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final List<Color> colors;

  PieChartPainter(this.data) : colors = _getColors();

  static List<Color> _getColors() {
    return [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = 0;
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = ((item['percentage'] as double? ?? 0.0) / 100) * 2 * 3.14159;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}