// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MonthState {
  final int month;
  MonthState(this.month);
}

class MonthInitial extends MonthState {
  MonthInitial(super.month);
}

class MonthCubit extends Cubit<MonthState> {
  MonthCubit() : super(MonthInitial(0));
  void reset() {
    emit(MonthInitial(DateTime.now().month));
  }

  void decrement() {
    int l = state.month - 1;
    if (l < 0) l = 11;
    emit(MonthInitial(l));
  }

  void increment() {
    int l = state.month + 1;
    if (l > 11) l = 0;
    emit(MonthInitial(l));
  }
}
