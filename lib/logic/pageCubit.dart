// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PageState {
  final bool isAuthenticated;
  PageState({required this.isAuthenticated});
}

class PageInitial extends PageState {
  PageInitial({required super.isAuthenticated});
}

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageInitial(isAuthenticated: false));
  void refresh(isAuthenticated) {
    emit(PageInitial(isAuthenticated: isAuthenticated));
  }
}
