import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/constant/chart_data.dart';
import 'package:meal/database/mealDB.dart';
import 'package:meal/database/paymentDB.dart';
import 'package:meal/models/models.dart';

abstract class SummaryState {
  final int meals;
  final int payment;
  final int payback;
  final List<ChartData> cumulativeMeal;

  SummaryState(this.meals, this.payment, this.payback, this.cumulativeMeal);
}

class SummaryInitial extends SummaryState {
  SummaryInitial(
      super.meals, super.payment, super.payback, super.cumulativeMeal);
}

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit() : super(SummaryInitial(0, 0, 0, []));
  Future<void> getRecent(int month) async {
    int meals = await MealDB.getTotal(month);
    int payments = await PaymentDB.getTotal(month);
    int payback = 0;
    List<Meal> allMeal = await MealDB.getMeals(month);
    List<ChartData> cumulativeMeal = [];
    double cumulative = 0;
    for (var element in allMeal) {
      cumulative += element.amount;
      cumulativeMeal.add(ChartData(element.day, cumulative));
    }
    emit(SummaryInitial(meals, payments, payback, cumulativeMeal));
  }
}
