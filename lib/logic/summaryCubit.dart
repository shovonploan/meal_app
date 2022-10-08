import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/constant/chart_data.dart';
import 'package:meal/database/mealDB.dart';
import 'package:meal/database/pay_backDB.dart';
import 'package:meal/database/paymentDB.dart';
import 'package:meal/models/models.dart';

abstract class SummaryState {
  final double meals;
  final int payment;
  final int payback;
  final bool show;
  final List<ChartData> cumulativeMeal;

  SummaryState(
      this.meals, this.payment, this.payback, this.cumulativeMeal, this.show);
}

class SummaryInitial extends SummaryState {
  SummaryInitial(super.meals, super.payment, super.payback,
      super.cumulativeMeal, super.show);
}

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit() : super(SummaryInitial(0, 0, 0, [], true));
  Future<void> getRecent(int month) async {
    double meals = await MealDB.getTotal(month);
    int payment = await PaymentDB.getTotal(month);
    int payback = await PayBackDB.getAmount(month);
    List<Meal> allMeal = await MealDB.getMeals(month);
    List<ChartData> cumulativeMeal = [];
    double cumulative = 0;
    for (var element in allMeal) {
      cumulative += element.amount;
      cumulativeMeal.add(ChartData(element.day, cumulative));
    }
    emit(SummaryInitial(meals, payment, payback, cumulativeMeal, true));
  }

  void show() {
    emit(SummaryInitial(
        state.meals, state.payment, state.payback, state.cumulativeMeal, true));
  }

  void hide() {
    emit(SummaryInitial(state.meals, state.payment, state.payback,
        state.cumulativeMeal, false));
  }
}
