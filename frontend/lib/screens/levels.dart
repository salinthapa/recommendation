import 'package:flutter/material.dart';
import 'package:gymapplication/api/api.dart';

import 'package:gymapplication/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/widgets/navbar.dart';
import 'package:gymapplication/screens/beginner.dart';
import 'package:gymapplication/screens/advance.dart';
import 'package:gymapplication/screens/intermediate.dart';

import 'package:gymapplication/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Begineer": {
    "image":
        "https://images.unsplash.com/photo-1518611012118-696072aa579a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJlZ2luZWVyJTIwZ3ltfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
  },
  "Intermediate": {
    "image":
        "https://images.unsplash.com/photo-1519505907962-0a6cb0167c73?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fGJlZ2luZWVyJTIwZ3ltfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
  },
  "Advance": {
    "image":
        "https://images.unsplash.com/photo-1605296867724-fa87a8ef53fd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8NiUyMHBhY2t8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
  }
};

class Level extends StatefulWidget {
  Level({Key key}) : super(key: key);

  @override
  _LevelState createState() => _LevelState();
}

class _LevelState extends State<Level> {
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
                    title: "Beginners level",
                    pic: articlesCards["Begineer"]["image"],
                    tap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Beginner(),
                      ));
                    },
                  ),
                  CardCategory(
                    title: "Intermediate Level",
                    pic: articlesCards["Intermediate"]["image"],
                    tap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Intermediate(),
                      ));
                    },
                  ),
                  CardCategory(
                    title: "Advanced Level",
                    pic: articlesCards["Advance"]["image"],
                    tap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Advance(),
                      ));
                    },
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
