import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal/logic/dateCubit.dart';
import 'package:meal/logic/mealCubit.dart';
import 'package:meal/logic/monthCubit.dart';
import 'package:meal/logic/pageCubit.dart';
import 'package:meal/logic/paymentCubit.dart';
import 'package:meal/logic/scrollCubit.dart';
import 'package:meal/logic/summaryCubit.dart';
import 'package:meal/pages/authenticte.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PageCubit()),
          BlocProvider(create: (context) => ScrollCubit()),
          BlocProvider(create: (context) => MonthCubit()),
          BlocProvider(create: (context) => DateCubit()),
          BlocProvider(create: (context) => MealCubit()),
          BlocProvider(create: (context) => PaymentCubit()),
          BlocProvider(create: (context) => SummaryCubit()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(392, 781),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const AuthenticationPage(),
          ),
        ),
      );
}
