// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/database/paymentDB.dart';
import 'package:meal/models/models.dart';

abstract class PaymentState {
  final List<Payment> payments;
  PaymentState(this.payments);
}

class PaymentInitial extends PaymentState {
  PaymentInitial(super.payments);
}

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial([]));
  Future<void> getRecent(int month) async {
    List<Payment> payments = await PaymentDB.getPayments(month);
    emit(PaymentInitial(payments));
  }
}
