import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal/constant/chart_data.dart';
import 'package:meal/constant/month.dart';
import 'package:meal/logic/mealCubit.dart';
import 'package:meal/logic/monthCubit.dart';
import 'package:meal/logic/paymentCubit.dart';
import 'package:meal/logic/summaryCubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MealCubit>(context).getRecent(DateTime.now().month);
    BlocProvider.of<PaymentCubit>(context).getRecent(DateTime.now().month);
    BlocProvider.of<SummaryCubit>(context).getRecent(DateTime.now().month);
    BlocProvider.of<MonthCubit>(context).reset();
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Column(
        children: [
          Container(
            width: 1.sw,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(72, 191, 227, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
            child: Center(
              child: Container(
                width: 0.9.sw,
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.7),
                      width: 3.sp),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          BlocProvider.of<MonthCubit>(context).decrement();
                          BlocProvider.of<MealCubit>(context).getRecent(
                              BlocProvider.of<MonthCubit>(context).state.month);
                          BlocProvider.of<PaymentCubit>(context).getRecent(
                              BlocProvider.of<MonthCubit>(context).state.month);
                          BlocProvider.of<SummaryCubit>(context).getRecent(
                              BlocProvider.of<MonthCubit>(context).state.month);
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.angleLeft,
                          color: Colors.white,
                        ),
                      ),
                      BlocBuilder<MonthCubit, MonthState>(
                          builder: (context, state) {
                        return Text(
                          month[state.month - 1],
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                      InkWell(
                        onTap: () {
                          BlocProvider.of<MonthCubit>(context).increment();
                          BlocProvider.of<MealCubit>(context).getRecent(
                              BlocProvider.of<MonthCubit>(context).state.month);
                          BlocProvider.of<PaymentCubit>(context).getRecent(
                              BlocProvider.of<MonthCubit>(context).state.month);
                          BlocProvider.of<SummaryCubit>(context).getRecent(
                              BlocProvider.of<MonthCubit>(context).state.month);
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.angleRight,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<SummaryCubit, SummaryState>(
            builder: (context, state) => state.cumulativeMeal.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp),
                      ),
                    ),
                  )
                : Container(),
          ),
          BlocBuilder<SummaryCubit, SummaryState>(
            builder: (context, state) => state.cumulativeMeal.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 0.95.sw,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(
                          20.r,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          line("Meal", state.meals.toString()),
                          line("Payment", state.payment.toString()),
                          line("Pay Back", state.payback.toString()),
                          line(
                              "C/M",
                              (state.meals / (state.payment - state.payback))
                                  .toStringAsFixed(2)),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
          BlocBuilder<SummaryCubit, SummaryState>(
              builder: (context, state) => state.cumulativeMeal.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(
                            20.r,
                          ),
                        ),
                        child: SfCartesianChart(
                          plotAreaBackgroundColor: Colors.white,
                          title: ChartTitle(
                            text: "Meal Taken",
                            textStyle: ts(),
                          ),
                          zoomPanBehavior: ZoomPanBehavior(
                            enablePinching: true,
                            enablePanning: true,
                          ),
                          primaryXAxis: CategoryAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle: ts(),
                              ),
                              minorGridLines: const MinorGridLines(
                                  color: Colors.black26, dashArray: [2.5]),
                              majorGridLines: const MajorGridLines(
                                  color: Colors.black54, dashArray: [5, 2.5]),
                              maximum: monthRange[month[
                                  BlocProvider.of<MonthCubit>(context)
                                      .state
                                      .month]]),
                          primaryYAxis: CategoryAxis(
                            title: AxisTitle(
                              text: 'Amount',
                              textStyle: ts(),
                            ),
                          ),
                          series: <ChartSeries>[
                            LineSeries<ChartData, int>(
                              dataSource: state.cumulativeMeal,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              color: Colors.red,
                              isVisibleInLegend: true,
                              markerSettings: const MarkerSettings(
                                height: 15,
                                width: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container()),
        ],
      ),
    );
  }

  Row line(String heading, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80.w,
          child: Center(
            child: Text(
              heading,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 8,
            lightSource: LightSource.bottom,
            color: const Color.fromARGB(255, 216, 215, 215),
          ),
          child: SizedBox(
            width: 80.w,
            height: 30.h,
            child: Center(
              child: Text(amount),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle ts() {
    return const TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  }
}
