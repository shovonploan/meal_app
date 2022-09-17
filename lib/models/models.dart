import 'dart:convert';

String tableMeal = "meal";
String tablePayment = "Payment";

class MealFields {
  static const List<String> values = [id, amount, day, month, year];
  static const String id = "id";
  static const String amount = "amount";
  static const String day = "day";
  static const String month = "month";
  static const String year = "year";
}

class PaymentFields {
  static const List<String> values = [id, amount, day, month, year];
  static const String id = "id";
  static const String amount = "amount";
  static const String day = "day";
  static const String month = "month";
  static const String year = "year";
}

class Meal {
  final int? id;
  final int amount;
  final int day;
  final int month;
  final int year;
  Meal({
    this.id,
    required this.amount,
    required this.day,
    required this.month,
    required this.year,
  });

  Meal copyWith({
    int? id,
    int? amount,
    int? day,
    int? month,
    int? year,
  }) {
    return Meal(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      amount: map['amount'],
      day: map['day'],
      month: map['month'],
      year: map['year'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Meal.fromJson(String source) => Meal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Meal(id: $id, amount: $amount, day: $day, month: $month, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meal &&
        other.id == id &&
        other.amount == amount &&
        other.day == day &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        day.hashCode ^
        month.hashCode ^
        year.hashCode;
  }
}

class Payment {
  final int? id;
  final int amount;
  final int day;
  final int month;
  final int year;
  Payment({
    this.id,
    required this.amount,
    required this.day,
    required this.month,
    required this.year,
  });

  Payment copyWith({
    int? id,
    int? amount,
    int? day,
    int? month,
    int? year,
  }) {
    return Payment(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      amount: map['amount'],
      day: map['day'],
      month: map['month'],
      year: map['year'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Payment(id: $id, amount: $amount, day: $day, month: $month, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Payment &&
        other.id == id &&
        other.amount == amount &&
        other.day == day &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        day.hashCode ^
        month.hashCode ^
        year.hashCode;
  }
}
