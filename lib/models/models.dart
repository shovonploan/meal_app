import 'dart:convert';

String tableMeal = "meal";
String tablePayment = "payment";
String tablePayBack = "payback";

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

class PayBackFields {
  static const List<String> values = [id, amount, month, year];
  static const String id = "id";
  static const String amount = "amount";
  static const String month = "month";
  static const String year = "year";
}

class Meal {
  final int? id;
  final double amount;
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
    double? amount,
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
      id: map['id']?.toInt(),
      amount: map['amount']?.toDouble() ?? 0.0,
      day: map['day']?.toInt() ?? 0,
      month: map['month']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
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

class PayBack {
  final int? id;
  final int amount;
  final int month;
  final int year;
  PayBack({
    this.id,
    required this.amount,
    required this.month,
    required this.year,
  });

  PayBack copyWith({
    int? id,
    int? amount,
    int? month,
    int? year,
  }) {
    return PayBack(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'month': month,
      'year': year,
    };
  }

  factory PayBack.fromMap(Map<String, dynamic> map) {
    return PayBack(
      id: map['id']?.toInt(),
      amount: map['amount']?.toInt() ?? 0,
      month: map['month']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PayBack.fromJson(String source) =>
      PayBack.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PayBack(id: $id, amount: $amount, month: $month, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PayBack &&
        other.id == id &&
        other.amount == amount &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode {
    return id.hashCode ^ amount.hashCode ^ month.hashCode ^ year.hashCode;
  }
}
