// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal/auth/local_auth_api.dart';
import 'package:meal/logic/monthCubit.dart';
import 'package:meal/logic/pageCubit.dart';
import 'package:meal/pages/meal/meal_page.dart';
import 'package:meal/pages/payment/payment_page.dart';
import 'package:meal/pages/summary/summary_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAuth() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      BlocProvider.of<PageCubit>(context).refresh(isAuthenticated);
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PageCubit, PageState>(builder: (context, state) {
        BlocProvider.of<MonthCubit>(context).reset();
        return !state.isAuthenticated
            ? DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromRGBO(78, 168, 222, 1),
                    bottom: const TabBar(
                      tabs: [
                        Tab(icon: FaIcon(FontAwesomeIcons.bowlFood)),
                        Tab(icon: FaIcon(FontAwesomeIcons.moneyBillWave)),
                        Tab(icon: FaIcon(FontAwesomeIcons.chartLine)),
                      ],
                    ),
                    title: Center(
                      child: Text(
                        'Meal Management',
                        style: TextStyle(fontSize: 32.sp),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.black,
                  body: const TabBarView(
                    children: [
                      MealPage(),
                      PaymentPage(),
                      SummaryPage(),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.black,
                body: Column(
                  children: [
                    SizedBox(height: 180.h),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          final isAuthenticated =
                              await LocalAuthApi.authenticate();
                          if (isAuthenticated) {
                            BlocProvider.of<PageCubit>(context)
                                .refresh(isAuthenticated);
                          }
                        },
                        child: Text(
                          "Authenticate",
                          style: TextStyle(
                              fontSize: 42.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(116, 0, 184, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      });
}
