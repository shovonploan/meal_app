import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal/constant/month.dart';
import 'package:meal/database/mealDB.dart';
import 'package:meal/logic/dateCubit.dart';
import 'package:meal/logic/mealCubit.dart';
import 'package:meal/logic/monthCubit.dart';
import 'package:meal/logic/paymentCubit.dart';
import 'package:meal/logic/scrollCubit.dart';
import 'package:meal/logic/summaryCubit.dart';
import 'package:meal/models/models.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  String data = "";
  RegExp rg = RegExp(r'\d+(?:\.\d{1,1})?$');
  late Animation<double> scaleAnimation;
  TextEditingController tx = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    tx.dispose();
    super.dispose();
  }

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

  String formate(int num) {
    if (num >= 10) return num.toString();
    return "0$num";
  }

  TextStyle style() => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: const Color.fromARGB(255, 18, 59, 21),
      );

  void add(DateState state, BuildContext context) {
    if (rg.hasMatch(data)) {
      Meal meal = Meal(
          amount: double.parse(data),
          day: state.date.day,
          weekDay: state.date.weekday,
          month: state.date.month,
          year: state.date.year);
      MealDB.create(meal);
      BlocProvider.of<MealCubit>(context)
          .getRecent(BlocProvider.of<MonthCubit>(context).state.month);
      data = "";
      BlocProvider.of<DateCubit>(context).reset();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SizedBox(
            height: 50.h,
            child: const Center(
              child: Text('Use Number Only'),
            ),
          ),
          duration: const Duration(milliseconds: 1500),
          width: 0.9.sw,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void edit(MealState state, int index, BuildContext context) {
    if (rg.hasMatch(data)) {
      Meal meal = Meal(
          id: state.meals[index].id,
          amount: double.parse(data),
          day: BlocProvider.of<DateCubit>(context).state.date.day,
          weekDay: BlocProvider.of<DateCubit>(context).state.date.weekday,
          month: BlocProvider.of<DateCubit>(context).state.date.month,
          year: BlocProvider.of<DateCubit>(context).state.date.year);
      MealDB.update(meal);
      BlocProvider.of<MealCubit>(context)
          .getRecent(BlocProvider.of<MonthCubit>(context).state.month);
      data = "";
      tx.text = "";
      BlocProvider.of<DateCubit>(context).reset();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SizedBox(
            height: 50.h,
            child: const Center(
              child: Text('Use Number Only'),
            ),
          ),
          duration: const Duration(milliseconds: 1500),
          width: 0.9.sw,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: BlocBuilder<ScrollCubit, ScrollState>(builder: (context, state) {
        BlocProvider.of<MealCubit>(context)
            .getRecent(BlocProvider.of<MonthCubit>(context).state.month);
        BlocProvider.of<PaymentCubit>(context)
            .getRecent(BlocProvider.of<MonthCubit>(context).state.month);
        BlocProvider.of<SummaryCubit>(context)
            .getRecent(BlocProvider.of<MonthCubit>(context).state.month);
        return Column(
          children: [
            Flexible(
              flex: 8,
              child: BlocBuilder<MealCubit, MealState>(
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
                  child: state.meals.isEmpty
                      ? Center(
                          child: Text(
                            "No Meal Yet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.meals.length,
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
                                      MealDB.delete(
                                          state.meals[index].id as int);
                                      BlocProvider.of<MealCubit>(context)
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
                                    onPressed: (context) {
                                      tx.text =
                                          state.meals[index].amount.toString();
                                      data = tx.text;
                                      showDialog(
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
                                                        color: const Color
                                                                .fromRGBO(
                                                            100, 223, 223, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Flexible(
                                                            child: TextField(
                                                              controller: tx,
                                                              onSubmitted:
                                                                  (value) => edit(
                                                                      state,
                                                                      index,
                                                                      context),
                                                              onChanged:
                                                                  (value) {
                                                                data = value;
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
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
                                                                        initialDate:
                                                                            state
                                                                                .date,
                                                                        firstDate: DateTime(
                                                                            2020,
                                                                            8),
                                                                        lastDate:
                                                                            DateTime.now()) as DateTime;
                                                                    // ignore: use_build_context_synchronously
                                                                    BlocProvider.of<DateCubit>(
                                                                            context)
                                                                        .refresh(
                                                                            date);
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .calendar_month),
                                                                ),
                                                              ),
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
                                                                onPressed: () =>
                                                                    edit(
                                                                        state,
                                                                        index,
                                                                        context),
                                                                child: Text(
                                                                  "Edit",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        94,
                                                                        96,
                                                                        206,
                                                                        1),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  data = "";
                                                                  tx.text = "";
                                                                  BlocProvider.of<
                                                                              DateCubit>(
                                                                          context)
                                                                      .reset();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  "Cancel",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        94,
                                                                        96,
                                                                        206,
                                                                        1),
                                                                  ),
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
                                      );
                                    },
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
                                        "${state.meals[index].day} ${month[state.meals[index].month - 1]}",
                                        style: style(),
                                      ),
                                      Text(
                                        state.meals[index].amount.toString(),
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
                                    BlocProvider.of<SummaryCubit>(context)
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
                                    BlocProvider.of<SummaryCubit>(context)
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
                                            child: TextField(
                                              onSubmitted: (value) =>
                                                  add(state, context),
                                              onChanged: (value) {
                                                data = value;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
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
                                                  // ignore: use_build_context_synchronously
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
                                                onPressed: () =>
                                                    add(state, context),
                                                child: Text(
                                                  "Add",
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: const Color.fromRGBO(
                                                        94, 96, 206, 1),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  data = "";
                                                  BlocProvider.of<DateCubit>(
                                                          context)
                                                      .reset();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: const Color.fromRGBO(
                                                        94, 96, 206, 1),
                                                  ),
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
}
