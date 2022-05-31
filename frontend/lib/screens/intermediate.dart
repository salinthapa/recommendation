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
        "1. 15 squats x 3\n2. 15 knee push-ups x 3 \n3. 12 triceps dips x 3 \n4. 30 step-ups x 3\n5. 16 backward lunges (8 each leg) x 3 \n6. 12 overhead triceps extensions x 3\n",
    "name": "Monday"
  },
  "1": {
    "Sets":
        "1. 16 forward lunges (8 each leg) x 3 \n2. 15 dumbbell hammer curls x 3\n3. 15 glute bridges x 3 \n4. 15 bicep curls x 3 \n5. 15 dumbbell rows x 3\n6. 15 stiff leg deadlifts x \n",
    "name": "Tuesday"
  },
  "2": {
    "Sets":
        "1. 20 Russian twists x 3 \n2. 30-second planks x 3\n3. 20 leg raises x \n",
    "name": "Wednesday"
  },
  "3": {
    "Sets":
        "1. 15 squats x 3\n2. 15 knee push-ups x 3\n3. 12 triceps dips x3\n4. 30 step ups x3\n5. 16 backward lunges (8 each leg) x3\n6. 12 overhead triceps extension x3\n",
    "name": "Thursday"
  },
  "4": {
    "Sets":
        "1. 16 forward lunges ( 6 each leg)\n2. 15 dumbbell hammer curls x3 \n3. 15 glute bridges x3 \n4. 15 bicep curls x3\n5. 15 dumbbell rows x3\n6. 15 stiff leg deadlifts x\n",
    "name": "Friday"
  },
  "4": {
    "Sets":
        "1. 30-45 minutes minute walking (low-intensity steady state cardio)",
    "name": "Saturday"
  },
  "5": {"Sets": "Sunday", "name": "Rest Day"},
};
final Map<String, dynamic> week2 = {
  "0": {
    "Sets":
        "1. 150 jumping Jacks \n2. 50 crunches \n3. 12 triceps dips x 3 \n4. 20 lunges (each leg) x3\n5. 70 russian twists x2\n6. 20 standing calf raises x3\n7. 5 push-ups x3\n8. 30 second plank x3\n9. 10 lunge split jumps x\n",
    "name": "Monday"
  },
  "1": {
    "Sets":
        "1. 60 jumping jacks x2\n2. 50 vertical leg crunches x2\n3. 20 sit-ups x3\n4. 15 tricep dips x3\n5. 20 squats x3\n6. 10 sido lunges x3\n7. 15 legifts (each leg) x3\n8. 50 bicycles x3\n9. 15 wall push-ups x3\n10. 40 russian twists x2\n",
    "name": "Tuesday"
  },
  "2": {
    "Sets":
        "1. 90 jumping jacks x2\n2. 20 tricep dips x3\n3. 10 sit-ups x3\n4. 30 bird-dogs x3\n5. 30 second plank x3\n6. 30 squats x3\n7. 40 crunches x3\n8. 10 oblique crunches x3\n9. 20 standing call raises x\n",
    "name": "Wednesday"
  },
  "3": {
    "Sets":
        "1. 100 jumping jacks x2\n2. 25 vertical leg crunches x3\n3. 20 squats x3\n4. 20 wall pushups x3\n5. 50 russian twists x3\n6. 15 second side plank  x3\n7. 10 lunge split jumps x3\n8. 5 jump squats x3\n9. 40 high knees x\n",
    "name": "Thursday"
  },
  "4": {
    "Sets":
        "1. 60 jumping Jacks x3\n2. 40 crunches x3 \n3. 10 sit-ups x3 \n4. 10 tricep dips x3\n5. 20 side lunges (each side) x3\n6. 15 Incline push-ups x3\n7. 10 oblique crunches x3\n8. 30 buttkickers x3\n9. 5 jump squats x3\n10. 15 jack knife sit-ups x\n",
    "name": "Friday"
  },
  "5": {
    "Sets":
        "1. 50 jumping jacka x3\n2. 20 squats x\n3. 100 russian twists x\n4. 5 kneeling pushups x\n5. 1 minute downward dog x\n6. 15 jock knife sit-ups x\n7. 10 lunges (each leg) x\n8. 10 side lunges (each side) x\n9. 20 bird dogs x\n10. 20 inner thigh lifts (each leg) x\n",
    "name": "Saturday"
  },
  "6": {
    "Sets":
        "1. 45 jumping Jacks x3 \n2. 15 squats x3\n3. 5 jump squats x3\n4. 50 russian twists x3\n5. 30 second plank x3\n6. 10 standing calf raises x3\n7. 5 kneeling push-ups x3\n8. 30 second superman x3\n9. 10 lunges (each leg) x3\n10. 40 crunches x3\n",
    "name": "Sunday"
  },
};
final Map<String, dynamic> week3 = {
  "0": {
    "Sets":
        "1. 10 V push ups x4\n2. 15 left forward lunges x4\n3. 15 right forward lunges x4\n4. 25 jumping jacks x4\n5. 20 Russian twists x4\n6. 60 sec plank x4\n7. 15 calf raises x\n",
    "name": "Monday"
  },
  "1": {
    "Sets":
        "1. 30 sec high knees x4 \n2. 1 minute walk in place x4\n3. 30 sec jog in place x4\n4. 1 minute walk in place x4\n5. 15 dumbbell rows x 3\n6. 30 sec butt kicks x4\n7. 1 minute walk in place x\n",
    "name": "Tuesday"
  },
  "2": {
    "Sets":
        "1. 15 wall push ups x4 \n2. 25 plie squats x4\n3. 25 leg lifts x4\n4. 25 plank jacks x4\n5. 30 sec plank x4\n6. 15 calf raises x\n",
    "name": "Wednesday"
  },
  "3": {
    "Sets":
        "1. 30 sec jumping jacks x4\n2. 1 minute walk in place x4\n3. 30 sec high knees x4\n4. 1 minute walk in place x4\n5. 30 sec butt kicks x4\n6. 1 minute walk in place x\n",
    "name": "Thursday"
  },
  "4": {
    "Sets":
        "1. 10 V push ups x4\n2. 25 plie squats x4\n3. 25 plank jacks x4\n4. 20 Russian twists x4\n5. 60 sec plank x4\n6. 15 calf raises x\n",
    "name": "Friday"
  },
  "5": {"Sets": "Rest day", "name": "Saturday"},
  "6": {"Sets": "Rest day", "name": "Sunday"},
};

class Intermediate extends StatefulWidget {
  @override
  _IntermediateState createState() => _IntermediateState();
}

class _IntermediateState extends State<Intermediate> {
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
                              new Workout(workout: week1, length: 5),
                        ));
                      }),
                  CardCategory(
                      title: "Week Two",
                      pic: articlesCards["two"]["image"],
                      tap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new Workout(workout: week2, length: 5),
                        ));
                      }),
                  CardCategory(
                      title: "Week Three",
                      pic: articlesCards["three"]["image"],
                      tap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new Workout(workout: week3, length: 5),
                        ));
                      }),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
