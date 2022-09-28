import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal/constant/month.dart';
import 'package:meal/database/paymentDB.dart';
import 'package:meal/logic/dateCubit.dart';
import 'package:meal/logic/mealCubit.dart';
import 'package:meal/logic/monthCubit.dart';
import 'package:meal/logic/paymentCubit.dart';
import 'package:meal/logic/scrollCubit.dart';
import 'package:meal/models/models.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> scaleAnimation;
  late AnimationController controller;
  String data = "";
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: BlocBuilder<ScrollCubit, ScrollState>(builder: (context, state) {
        BlocProvider.of<MealCubit>(context).getRecent(DateTime.now().month);
        BlocProvider.of<PaymentCubit>(context).getRecent(DateTime.now().month);
        BlocProvider.of<MonthCubit>(context).reset();
        return Column(
          children: [
            Flexible(
              flex: 8,
              child: BlocBuilder<PaymentCubit, PaymentState>(
                builder: (BuildContext context, state) =>
                    NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                      BlocProvider.of<ScrollCubit>(context).refresh(0);
                    } else if (scrollNotification is ScrollEndNotification) {
                      BlocProvider.of<ScrollCubit>(context).refresh(1);
                    }
                    return false;
                  },
                  child: state.payments.isEmpty
                      ? Center(
                          child: Text(
                            "No Payment Done",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.payments.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Slidable(
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(20.r),
                                    onPressed: (context) {
                                      PaymentDB.delete(
                                          state.payments[index].id as int);
                                      BlocProvider.of<PaymentCubit>(context)
                                          .getRecent(
                                              BlocProvider.of<MonthCubit>(
                                                      context)
                                                  .state
                                                  .month);
                                    },
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  )
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(20.r),
                                    onPressed: (context) => showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return WillPopScope(
                                          onWillPop: () async => false,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: ScaleTransition(
                                              scale: scaleAnimation,
                                              child: Container(
                                                color: Colors.transparent,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        50, 200, 50, 400),
                                                child: Center(
                                                  child: Container(
                                                    width: 0.8.sw,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              100, 223, 223, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Flexible(
                                                          child: WheelChooser
                                                              .integer(
                                                            onValueChanged:
                                                                (i) => data = i
                                                                    .toString(),
                                                            horizontal: true,
                                                            maxValue: 2000,
                                                            minValue: 100,
                                                            step: 100,
                                                            initValue: state
                                                                .payments[index]
                                                                .amount,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            BlocBuilder<
                                                                    DateCubit,
                                                                    DateState>(
                                                                builder: (context,
                                                                        state) =>
                                                                    Text(
                                                                      "${state.date.day}/${state.date.month}",
                                                                      style: TextStyle(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color:
                                                                              Colors.black),
                                                                    )),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            BlocBuilder<
                                                                    DateCubit,
                                                                    DateState>(
                                                                builder: (context,
                                                                        state) =>
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        final DateTime date = await showDatePicker(
                                                                            context:
                                                                                context,
                                                                            initialDate: state
                                                                                .date,
                                                                            firstDate: DateTime(2020,
                                                                                8),
                                                                            lastDate:
                                                                                DateTime.now()) as DateTime;
                                                                        BlocProvider.of<DateCubit>(context)
                                                                            .refresh(date);
                                                                      },
                                                                      child: const Icon(
                                                                          Icons
                                                                              .calendar_month),
                                                                    )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                if (data !=
                                                                    "") {
                                                                  Payment payment = Payment(
                                                                      id: state
                                                                          .payments[
                                                                              index]
                                                                          .id,
                                                                      amount: int
                                                                          .parse(
                                                                              data),
                                                                      day: BlocProvider.of<DateCubit>(
                                                                              context)
                                                                          .state
                                                                          .date
                                                                          .day,
                                                                      month: BlocProvider.of<DateCubit>(
                                                                              context)
                                                                          .state
                                                                          .date
                                                                          .month,
                                                                      year: BlocProvider.of<DateCubit>(
                                                                              context)
                                                                          .state
                                                                          .date
                                                                          .year);
                                                                  PaymentDB.update(
                                                                      payment);
                                                                  BlocProvider.of<
                                                                              PaymentCubit>(
                                                                          context)
                                                                      .getRecent(BlocProvider.of<MonthCubit>(
                                                                              context)
                                                                          .state
                                                                          .month);
                                                                  data = "";
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              },
                                                              child: Text(
                                                                "Edit",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        94,
                                                                        96,
                                                                        206,
                                                                        1)),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                data = "";
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        94,
                                                                        96,
                                                                        206,
                                                                        1)),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    backgroundColor: Colors.greenAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  )
                                ],
                              ),
                              child: Container(
                                width: 0.98.sw,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(128, 255, 219, 1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${state.payments[index].day} ${month[state.payments[index].month - 1]}",
                                        style: style(),
                                      ),
                                      Text(
                                        state.payments[index].amount.toString(),
                                        style: style(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Flexible(
              flex: state.flex,
              child: Container(
                width: 1.sw,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(72, 191, 227, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: state.flex == 1
                    ? Center(
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
                                    BlocProvider.of<MonthCubit>(context)
                                        .decrement();
                                    BlocProvider.of<MealCubit>(context)
                                        .getRecent(
                                            BlocProvider.of<MonthCubit>(context)
                                                .state
                                                .month);
                                    BlocProvider.of<PaymentCubit>(context)
                                        .getRecent(
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
                                    BlocProvider.of<MonthCubit>(context)
                                        .increment();
                                    BlocProvider.of<MealCubit>(context)
                                        .getRecent(
                                            BlocProvider.of<MonthCubit>(context)
                                                .state
                                                .month);
                                    BlocProvider.of<PaymentCubit>(context)
                                        .getRecent(
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
                      )
                    : Container(),
              ),
            )
          ],
        );
      }),
      floatingActionButton: BlocBuilder<ScrollCubit, ScrollState>(
        builder: (context, state) => state.flex == 1
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        data = "1";
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: Material(
                            color: Colors.transparent,
                            child: BlocBuilder<DateCubit, DateState>(
                              builder: (context, state) => ScaleTransition(
                                scale: scaleAnimation,
                                child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.fromLTRB(
                                      50, 200, 50, 400),
                                  child: Center(
                                    child: Container(
                                      width: 0.8.sw,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            100, 223, 223, 1),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Flexible(
                                            child: WheelChooser.integer(
                                              onValueChanged: (i) =>
                                                  data = i.toString(),
                                              horizontal: true,
                                              maxValue: 2000,
                                              minValue: 100,
                                              step: 100,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${state.date.day}/${state.date.month}",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  final DateTime date =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              state.date,
                                                          firstDate:
                                                              DateTime(2020, 8),
                                                          lastDate: DateTime
                                                              .now()) as DateTime;
                                                  BlocProvider.of<DateCubit>(
                                                          context)
                                                      .refresh(date);
                                                },
                                                child: const Icon(
                                                    Icons.calendar_month),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Payment payment = Payment(
                                                      amount: int.parse(data),
                                                      day: state.date.day,
                                                      month: state.date.month,
                                                      year: state.date.year);
                                                  PaymentDB.create(payment);
                                                  BlocProvider.of<PaymentCubit>(
                                                          context)
                                                      .getRecent(BlocProvider
                                                              .of<MonthCubit>(
                                                                  context)
                                                          .state
                                                          .month);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color:
                                                          const Color.fromRGBO(
                                                              94, 96, 206, 1)),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  data = "";
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color:
                                                          const Color.fromRGBO(
                                                              94, 96, 206, 1)),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    child: Icon(
                      Icons.add,
                      size: 42.sp,
                    ),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                ],
              )
            : Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  String formate(int num) {
    if (num >= 10) return num.toString();
    return "0$num";
  }

  TextStyle style() => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
      color: const Color.fromARGB(255, 18, 59, 21));
}
