import 'package:flutter/material.dart';

import 'package:gymapplication/constants/Theme.dart';

//widgets
import 'package:gymapplication/widgets/navbar.dart';
import 'package:gymapplication/widgets/card-horizontal.dart';
import 'package:gymapplication/widgets/card-small.dart';
import 'package:gymapplication/widgets/card-square.dart';
import 'package:gymapplication/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:now_ui_flutter/screens/product.dart';
import 'dart:convert';

final Map<String, Map<String, String>> homeCards = {
  "Gym": {
    "title": "GYMs",
    "image":
        "https://images.unsplash.com/photo-1558611848-73f7eb4001a1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGd5bXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"
  },
  "Trainers": {
    "title": "Trainers",
    "image":
        "https://images.unsplash.com/photo-1619361728853-2542f3864532?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8dHJhaW5lcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"
  },
  "Workout": {
    "title": "Workout",
    "image":
        "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"
  },
  "Diets": {
    "title": "Diets",
    "image":
        "https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=853&q=80"
  },
  "Appointment": {
    "title": "Appointment",
    "image":
        "https://images.unsplash.com/photo-1642489069222-3b8f36c0e89e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=392&q=80"
  },
};

Future<String> getUserInfo() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);

  int userType = user['role_id'];

  return userType.toString();
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<String> _role;

  @override
  void initState() {
    super.initState();

    _role = getUserInfo();
  }

  // final GlobalKey _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          title: "Home",
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        // key: _scaffoldKey,
        drawer: NowDrawer(currentPage: "Home"),
        body: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: FutureBuilder<String>(
            future: _role,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data == "1") {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Gym"]['title'],
                                img: homeCards["Gym"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/gym');
                                }),
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Trainers"]['title'],
                                img: homeCards["Trainers"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/trainer');
                                })
                          ],
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Workout"]['title'],
                                img: homeCards["Workout"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/workout');
                                }),
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Diets"]['title'],
                                img: homeCards["Diets"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/diet');
                                }),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.data == '2') {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Gym"]['title'],
                                img: homeCards["Gym"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/gym');
                                }),
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Trainers"]['title'],
                                img: homeCards["Trainers"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/trainer');
                                })
                          ],
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Workout"]['title'],
                                img: homeCards["Workout"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/workout');
                                })
                          ],
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Diets"]['title'],
                                img: homeCards["Diets"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/diet');
                                }),
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Appointment"]['title'],
                                img: homeCards["Appointment"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/appointment');
                                })
                          ],
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  );
                } else if (snapshot.data == '3') {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardSmall(
                                cta: "Open",
                                title: homeCards["Appointment"]['title'],
                                img: homeCards["Appointment"]['image'],
                                tap: () {
                                  Navigator.pushNamed(context, '/appointment');
                                })
                          ],
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
// By default show a loading spinner.
              return Text("");
            },
          ),
        ));
  }
}
