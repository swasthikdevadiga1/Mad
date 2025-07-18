class TransactionModel {
  int? id;
  String title;
  double amount;
  String category;
  DateTime date;
  String type; // 'income' or 'expense'
  int userId;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.userId,
  });
TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? type,
    int? userId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type,
      'userId': userId,
    };
  }

  static TransactionModel fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      type: map['type'],
      userId: map['userId'],
    );
  }
}