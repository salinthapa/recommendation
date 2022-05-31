import 'package:flutter/material.dart';

import 'package:gymapplication/screens/addTrainer.dart';
import 'package:gymapplication/screens/addGym.dart';
import 'package:gymapplication/screens/addGym.dart';
import 'package:gymapplication/screens/addAppointment.dart';
import 'package:gymapplication/screens/appointment.dart';

// screens

import 'package:gymapplication/screens/home.dart';

import 'package:gymapplication/screens/register.dart';

import 'package:gymapplication/screens/trainer.dart';
import 'package:gymapplication/screens/gym.dart';

import 'package:gymapplication/screens/levels.dart';

import 'package:gymapplication/screens/diet.dart';
import 'package:gymapplication/screens/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gym Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: '/login',
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) => new Home(),
          "/register": (BuildContext context) => new Register(),
          "/login": (BuildContext context) => new Login(),
          "/addAppointment": (BuildContext context) => new AddAppointment(),
          "/trainer": (BuildContext context) => new Trainer(),
          "/gym": (BuildContext context) => new Gym(),
          "/addTrainer": (BuildContext context) => new AddTrainer(),
          "/addGym": (BuildContext context) => new AddGym(),
          "/workout": (BuildContext context) => new Level(),
          "/appointment": (BuildContext context) => new Appointment(),
          "/diet": (BuildContext context) => new Diet(),
        });
  }
}
