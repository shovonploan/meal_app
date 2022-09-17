// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DateState {
  final DateTime date;
  DateState({
    required this.date,
  });
}

class DateInitial extends DateState {
  DateInitial({required super.date});
}

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateInitial(date: DateTime.now()));
  void refresh(DateTime date) {
    emit(DateInitial(date: date));
  }

  void reset() {
    emit(DateInitial(date: DateTime.now()));
  }
}
