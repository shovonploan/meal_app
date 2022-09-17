// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/database/mealDB.dart';
import 'package:meal/models/models.dart';

abstract class MealState {
  final List<Meal> meals;
  MealState(this.meals);
}

class MealInitial extends MealState {
  MealInitial(super.meals);
}

class MealCubit extends Cubit<MealState> {
  MealCubit() : super(MealInitial([]));
  Future<void> getRecent(int month) async {
    List<Meal> meals = await MealDB.getMeals(month);
    emit(MealInitial(meals));
  }
}
