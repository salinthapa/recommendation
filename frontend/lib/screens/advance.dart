import 'package:flutter/material.dart';
import 'package:gymapplication/api/api.dart';

import 'package:gymapplication/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/widgets/navbar.dart';
import 'package:gymapplication/screens/workout.dart';

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
        "1. 20 squats x4\n 2. 20 second plank  x4\n 3. 15 russian twists  x4\n 4. 30 jumping jacks  x4\n 5. 20 crunches  x4\n 6. 16 lunges  x4\n 7. 10 knee pull-ins  x4\n 8. 20 butt kicks  x4\n ",
    "name": "Monday"
  },
  "1": {
    "Sets":
        "1. 30 sec high knees x4 \n2. 1 minute walk in place x4\n3. 30 sec jog in place x4\n4. 1 minute walk in place x4\n5. 15 dumbbell rows x 3\n6. 30 sec butt kicks x4\n7. 1 minute walk in place x4\n",
    "name": "Tuesday"
  },
  "2": {
    "Sets":
        "1. 25 squats  x4\n2. 30 second plank  x4\n3. 20 russian twists  x4\n4. 25 plank jacks x4\n5. 35 jumping jacks  x4\n6. 25 crunches  x4\n7. 20 lunges  x4\n8. 15 knee pull-ins  x4\n9. 25 butt kicks x\n",
    "name": "Wednesday"
  },
  "3": {
    "Sets":
        "1. 30 squats  x4\n2. 55 second plank  x4\n3. 30 russian twists  x4\n4. 50 jumping jacks  x4\n5. 25 crunches  x4\n6. 20 lunges  x47. 15 knee pull-ins  x4\n8. 35 butt kicks x4",
    "name": "Thursday"
  },
  "4": {
    "Sets":
        "1. 35 squats  x4\n2. 60 second plank  x4\n3. 30 russian twists  x4\n4. 40 jumping jacks  x4\n5. 20 crunches x4\n6. 20 lunges x4\n7.20 lunges x4\n8. 15 knee pull-ins  x4\n9. 30 butt kicks x4\n",
    "name": "Friday"
  },
  "5": {"Sets": "1. Rest Day", "name": "Saturday"},
  "6": {
    "Sets":
        "1. 35 squats  x4\n2. 55 second plank  x4\n3. 30 russian twists  x4\n4. 50 jumping jacks  x4\n5. 25 crunches  x4\n6. 20 lunges  x4\n7. 15 knee pull-ins x4\n8. 35 butt kicks x4\n",
    "name": "Sunday"
  },
};

final Map<String, dynamic> week2 = {
  "0": {
    "Sets":
        "1. 20 Leg Extension x5\n2. 15 Squats x4\n3. 15 Leg Press x4\n4. 20 Single Leg Extension x3\n5. 30 Seated Calf Raises x4\n6. 12 Standing Calf Raises x4 ",
    "name": "Monday"
  },
  "1": {
    "Sets":
        "1. 20 Incline Bench Press x5\n2. 15 Incline Hammer Press x4\n3. 10 Dumbbell Flyes x4\n4. 12 Dumbbell Chest Press x4\n5. 20 Dips x3\n6. 10 Incline Skullcrusher x4",
    "name": "Tuesday"
  },
  "2": {
    "Sets":
        "1. 10 Lat Pulldown Wide Grip x4\n2. 10 Rows x5\n3. 15 One-Arm Dumbbell Row x3\n4. 15 Lat Pulldown Reverse Grip x3\n5. 35 jumping jacks  x4\n6. 20 Deadlifts x4\n7. 20 Hammer Curls x3\n8. 15 Preacher Dumbell Curls x3",
    "name": "Wednesday"
  },
  "3": {"Sets": "1. Rest day", "name": "Thursday"},
  "4": {
    "Sets":
        "1. 20 Seated Dumbbell Shoulder Press  x4\n2. 20 Seated Lateral Side Raises x4\n3. 20 Rear Delt Machine x4\n4. 25 Upright Rows x4\n5. 15 Dumbbell Shrugs x5",
    "name": "Friday"
  },
  "5": {"Sets": "Rest Day", "name": "Saturday"},
  "6": {"Sets": "Rest Day", "name": "Sunday"},
};

final Map<String, dynamic> week3 = {
  "0": {
    "Sets":
        "1. 25 Leg Extension x5\n2. 20 Squats x4\n3. 20 Leg Press x4\n4. 25 Single Leg Extension x3\n5. 30 Seated Calf Raises x4\n6. 15 Standing Calf Raises x4 ",
    "name": "Monday"
  },
  "1": {
    "Sets":
        "1. 25 Incline Bench Press x5\n2. 20 Incline Hammer Press x4\n3. 15 Dumbbell Flyes x4\n4. 15 Dumbbell Chest Press x4\n5. 25 Dips x3\n6. 15 Incline Skullcrusher x4",
    "name": "Tuesday"
  },
  "2": {
    "Sets":
        "1. 15 Lat Pulldown Wide Grip x4\n2. 15 Rows x5 \n3. 25 Lat Pulldown Reverse Grip x3\n4. 25 Deadlifts x4\n5. 25 Hammer Curls x3\n6. 20 Preacher Dumbell Curls x3",
    "name": "Wednesday"
  },
  "3": {"Sets": "Rest Day", "name": "Thursday"},
  "4": {
    "Sets":
        "1. 25 Seated Dumbbell Shoulder Press  x4\n2. 25 Seated Lateral Side Raises x4\n3. 25 Rear Delt Machine x4\n4. 30 Upright Rows x4\n5. 20 Dumbbell Shrugs x5",
    "name": "Friday"
  },
  "5": {"Sets": "Rest Day", "name": "Saturday"},
  "6": {
    "Sets":
        "1. 25 Lying Leg Curls x4\n2. 20 Stiff-Legged Deadlift x4\n3. 25 Hamstring One Leg Curls x4\n4. 20 Crunches x4\n5. 25 Hanging Leg Raises x3",
    "name": "Sunday"
  },
};

class Advance extends StatefulWidget {
  @override
  _AdvanceState createState() => _AdvanceState();
}

class _AdvanceState extends State<Advance> {
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
                          builder: (BuildContext context) =>
                              new Workout(workout: week1, length: 7),
                        ));
                      }),
                  CardCategory(
                      title: "Week Two",
                      pic: articlesCards["two"]["image"],
                      tap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new Workout(workout: week2, length: 7),
                        ));
                      }),
                  CardCategory(
                      title: "Week Three",
                      pic: articlesCards["three"]["image"],
                      tap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new Workout(workout: week3, length: 7),
                        ));
                      }),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
