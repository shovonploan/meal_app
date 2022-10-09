// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/constant/chart_data.dart';
import 'package:meal/database/mealDB.dart';
import 'package:meal/database/pay_backDB.dart';
import 'package:meal/database/paymentDB.dart';
import 'package:meal/models/models.dart';

abstract class SummaryState {
  SummaryState(this.meals, this.payment, this.payback, this.show,
      this.cumulativeMeal, this.weeklyMeal);

  final double meals;
  final int payback;
  final int payment;
  final bool show;
  final List<ChartData> cumulativeMeal;
  final List<ChartData2> weeklyMeal;
}

class SummaryInitial extends SummaryState {
  SummaryInitial(super.meals, super.payment, super.payback, super.show,
      super.cumulativeMeal, super.weeklyMeal);
}

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit() : super(SummaryInitial(0, 0, 0, true, [], []));

  Future<void> getRecent(int month) async {
    double meals = await MealDB.getTotal(month);
    int payment = await PaymentDB.getTotal(month);
    int payback = await PayBackDB.getAmount(month);
    List<Meal> allMeal = await MealDB.getMeals(month);
    List<ChartData> cumulativeMeal = [];
    List<ChartData2> weeklyMeal = [];
    double cumulative = 0;
    List<double> temp = [];
    for (var element in allMeal) {
      cumulative += element.amount;
      cumulativeMeal.add(ChartData(element.day, cumulative));
    }
    for (int i = 1; i <= 7; ++i) {
      double temp2 = await MealDB.getDayTotal(month, i);
      temp.add(temp2);
    }
    weeklyMeal.add(ChartData2("SUN", temp[6]));
    weeklyMeal.add(ChartData2("MON", temp[0]));
    weeklyMeal.add(ChartData2("TUE", temp[1]));
    weeklyMeal.add(ChartData2("WED", temp[2]));
    weeklyMeal.add(ChartData2("THR", temp[3]));
    weeklyMeal.add(ChartData2("FRI", temp[4]));
    weeklyMeal.add(ChartData2("SAT", temp[5]));
    emit(SummaryInitial(
        meals, payment, payback, true, cumulativeMeal, weeklyMeal));
  }

  void show() {
    emit(SummaryInitial(state.meals, state.payment, state.payback, true,
        state.cumulativeMeal, state.weeklyMeal));
  }

  void hide() {
    emit(SummaryInitial(state.meals, state.payment, state.payback, false,
        state.cumulativeMeal, state.weeklyMeal));
  }
}
