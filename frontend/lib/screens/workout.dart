import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymapplication/api/api.dart';

import 'package:gymapplication/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/widgets/navbar.dart';

import 'package:gymapplication/widgets/card-category.dart';
import 'package:gymapplication/widgets/card-square.dart';

import 'package:coupon_uikit/coupon_uikit.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Workout extends StatefulWidget {
  final Map<String, dynamic> workout;
  int length;
  Workout({this.workout, this.length});
  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String day;
  Map<String, dynamic> exercise;
  int numberOfExercise;
  @override
  void initState() {
    super.initState();
    exercise = widget.workout;
    numberOfExercise = widget.length;
    print(exercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Workouts",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Workout"),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: numberOfExercise,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(FontAwesomeIcons.dumbbell),
                                title:
                                    Text(exercise[(index).toString()]["name"]),
                                subtitle: Text('Exercise: \n' +
                                    exercise[(index).toString()]["Sets"] +
                                    '\n'),
                                isThreeLine: true,
                              ),
                            );
                          })),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
