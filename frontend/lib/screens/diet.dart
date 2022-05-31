import 'package:flutter/material.dart';
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

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View gym",
    "image":
        "https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=853&q=80",
  }
};

final Map<String, Map<String, dynamic>> weightLossDiet = {
  "Sunday": {
    "day": "Sunday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Monday": {
    "day": "Monday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Tuesday": {
    "day": "Tuesday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Wednesday": {
    "day": "Wednesday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Thursday": {
    "day": "Thursday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Friday": {
    "day": "Friday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Saturday": {
    "day": "Saturday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
};

final Map<String, Map<String, dynamic>> weightGainDiet = {
  "Sunday": {
    "day": "Sunday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Monday": {
    "day": "Monday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Tuesday": {
    "day": "Tuesday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Wednesday": {
    "day": "Wednesday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Thursday": {
    "day": "Thursday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Friday": {
    "day": "Friday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Saturday": {
    "day": "Saturday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
};

final Map<String, Map<String, dynamic>> muscularDiet = {
  "Sunday": {
    "day": "Sunday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Monday": {
    "day": "Monday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Tuesday": {
    "day": "Tuesday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Wednesday": {
    "day": "Wednesday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Thursday": {
    "day": "Thursday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Friday": {
    "day": "Friday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
  "Saturday": {
    "day": "Saturday",
    "breakfast": "Adi ityadi",
    "lunch": "Adi ityadi",
    "dinner": "Adi ityadi",
  },
};

class Diet extends StatefulWidget {
  Diet({Key key}) : super(key: key);

  @override
  _DietState createState() => _DietState();
}

class _DietState extends State<Diet> {
  String day;
  @override
  void initState() {
    super.initState();
    var date = DateTime.now();

    print(DateFormat('EEEE').format(date));
    day = DateFormat('EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Diets",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Diet"),
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
                  CardCategory(
                      title: day + "\nToday's Diets",
                      pic: articlesCards["Content"]["image"]),
                  Center(child: Text('Today\'s Diet to Lose Weight')),
                  Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.fastfood),
                                title: Text(weightLossDiet[day]["day"]),
                                subtitle: Text('Breakfast: ' +
                                    weightLossDiet[day]["breakfast"] +
                                    '\n' +
                                    'Lunch: ' +
                                    weightLossDiet[day]["lunch"] +
                                    '\n'
                                        'Dinner: ' +
                                    weightLossDiet[day]["dinner"] +
                                    '\n'),
                                isThreeLine: true,
                              ),
                            );
                          })),
                  SizedBox(height: 8.0),
                  Center(child: Text('Today\'s Diet to Gain Weight')),
                  Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.fastfood),
                                title: Text(weightGainDiet[day]["day"]),
                                subtitle: Text('Breakfast: ' +
                                    weightGainDiet[day]["breakfast"] +
                                    '\n' +
                                    'Lunch: ' +
                                    weightGainDiet[day]["lunch"] +
                                    '\n'
                                        'Dinner: ' +
                                    weightGainDiet[day]["dinner"] +
                                    '\n'),
                                isThreeLine: true,
                              ),
                            );
                          })),
                  SizedBox(height: 8.0),
                  Center(child: Text('Today\'s Diet to Build Muscle')),
                  Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.fastfood),
                                title: Text(muscularDiet[day]["day"]),
                                subtitle: Text('Breakfast: ' +
                                    muscularDiet[day]["breakfast"] +
                                    '\n' +
                                    'Lunch: ' +
                                    muscularDiet[day]["lunch"] +
                                    '\n'
                                        'Dinner: ' +
                                    muscularDiet[day]["dinner"] +
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
