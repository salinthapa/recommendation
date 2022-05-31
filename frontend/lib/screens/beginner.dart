import 'package:flutter/material.dart';
import 'package:gymapplication/api/api.dart';

import 'package:gymapplication/constants/Theme.dart';
import 'package:gymapplication/screens/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/widgets/navbar.dart';

import 'package:gymapplication/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "one": {
    "image":
        "https://images.unsplash.com/photo-1608228079968-c7681afb8f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FsZW5kZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
  },
  "two": {
    "image":
        "https://images.unsplash.com/photo-1608228079968-c7681afb8f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FsZW5kZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
  },
  "three": {
    "image":
        "https://images.unsplash.com/photo-1608228079968-c7681afb8f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FsZW5kZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
  },
  "four": {
    "image":
        "https://images.unsplash.com/photo-1608228079968-c7681afb8f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FsZW5kZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
  }
};
final Map<String, dynamic> week1 = {
  "0": {
    "Sets":
        "1. 20 squats \n 2. 15 seconds plank\n 3. 25 crunches\n 4. 15 lunges\n 5. 25 seconds wall sit \n 6. 10 sit-ups\n 7. 10 butt kicks\n 8. 5 push up\n ",
    "name": "Monday"
  },
  "1": {
    "Sets":
        "1. 10 Squats\n2. 30 seconds plank \n3. 25 crunches\n4. 10 jumping jacks \n5. 25 lunges\n6. 45 seconds wall sit\n7. 35 sit-ups\n8. 25 butt kicks\n9. 10 pushup\n",
    "name": "Tuesday"
  },
  "2": {
    "Sets":
        "1.15 squats \n2. 40 seconds plank\n3. 30 crunches\n4. 50 jumping jacks \n5. 25 lunges\n6. 35 seconds wall sit\n7. 30 sit-ups\n8. 25 butt kick\n",
    "name": "Wednesday"
  },
  "3": {
    "Sets":
        "1. 35 squats\n 2. 30 seconds plank\n 3. 20 crunches\n 4. 25 jumping jacks\n 5. 15 lunges\n 6. 60 seconds wall sits\n 7. 55 sit-ups\n 8. 35 butt kick\n ",
    "name": "Thursday"
  },
  "4": {
    "Sets":
        "1. 25 squats\n 2. 60 seconds plank\n 3. 30 crunches\n 4. 55 jumping jacks\n 5. 60 lunges\n 6. 45 seconds wall sit\n 7. 40 sit-ups\n 8. 50 butt kicks\n 9. 30 push up\n",
    "name": "Friday"
  },
  "5": {"Sets": "Rest Day Kiddo", "name": "Saturday"},
  "6": {"Sets": "Rest Day Kiddo", "name": "Sunday"},
};

class Beginner extends StatefulWidget {
  @override
  _BeginnerState createState() => _BeginnerState();
}

class _BeginnerState extends State<Beginner> {
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
                  CardCategory(
                      title: "Week One",
                      pic: articlesCards["one"]["image"],
                      tap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new Workout(
                            workout: week1,
                            length: 4,
                          ),
                        ));
                      }),
                  // CardCategory(
                  //     title: "Week Two",
                  //     pic: articlesCards["two"]["image"],
                  //     tap: () {
                  //       Navigator.of(context).push(new MaterialPageRoute(
                  //         builder: (BuildContext context) => new Workout(
                  //           workout: week2,
                  //           length: 4,
                  //         ),
                  //       ));
                  //     }),
                  // CardCategory(
                  //     title: "Week Three",
                  //     pic: articlesCards["three"]["image"],
                  //     tap: () {
                  //       Navigator.of(context).push(new MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             new Workout(workout: week3, length: 4),
                  //       ));
                  //     }),
                  // CardCategory(
                  //     title: "Beginner Four",
                  //     pic: articlesCards["four"]["image"],
                  //     tap: () {
                  //       Navigator.of(context).push(new MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             new Workout(workout: week4, length: 4),
                  //       ));
                  //     }),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
