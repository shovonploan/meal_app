// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ScrollState {
  final int flex;
  ScrollState({
    required this.flex,
  });
}

class ScrollInitial extends ScrollState {
  ScrollInitial({required super.flex});
}

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit() : super(ScrollInitial(flex: 1));
  void refresh(int flex) {
    emit(ScrollInitial(flex: flex));
  }
}
