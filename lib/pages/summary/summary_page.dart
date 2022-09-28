import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal/constant/month.dart';
import 'package:meal/logic/mealCubit.dart';
import 'package:meal/logic/monthCubit.dart';
import 'package:meal/logic/paymentCubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final List<ChartData> chartData = [
    ChartData(2010, 35),
    ChartData(2011, 28),
    ChartData(2012, 34),
    ChartData(2013, 32),
    ChartData(2014, 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: SingleChildScrollView(
        child: Column(
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
                                BlocProvider.of<MonthCubit>(context)
                                    .state
                                    .month);
                            BlocProvider.of<PaymentCubit>(context).getRecent(
                                BlocProvider.of<MonthCubit>(context)
                                    .state
                                    .month);
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
                                BlocProvider.of<MonthCubit>(context)
                                    .state
                                    .month);
                            BlocProvider.of<PaymentCubit>(context).getRecent(
                                BlocProvider.of<MonthCubit>(context)
                                    .state
                                    .month);
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
            Container(
                child: SfCartesianChart(series: <ChartSeries>[
              LineSeries<ChartData, int>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y)
            ]))
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
