import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:gymapplication/constants/Theme.dart';

//widgets
import 'package:gymapplication/widgets/navbar.dart';
import 'package:gymapplication/widgets/input.dart';
import 'package:gymapplication/screens/home.dart';
import 'package:gymapplication/widgets/drawer.dart';

import 'package:gymapplication/screens/register.dart';
import 'package:gymapplication/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _autovaliodate = false;
  bool _isLoading = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/gym.jfif"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16.0, right: 16.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.78,
                          color: NowUIColors.bgColorScreen,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, bottom: 8),
                                    child: Center(
                                        child: Text("Simzang Fitness",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Enter your email",
                                          onChanged: (value) {},
                                          controller: emailController,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Enter your password",
                                          controller: passwordController,
                                          pass: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press

                                        loginForm();
                                      },
                                      shape: RoundedRectangleBorder(),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Text("Login",
                                            style: TextStyle(fontSize: 14.0)),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.primary,
                                      color: NowUIColors.white,
                                      onPressed: () {
                                        // Respond to button press

                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => Register()),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Text("Register",
                                            style: TextStyle(fontSize: 14.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                ),
              ]),
            )
          ],
        ));
  }

  void loginForm() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'password': passwordController.text,
      'email': emailController.text,
    };

    var res = await CallApi().postDataWithoutToken(data, 'login');
    var body = json.decode(res.body);

    if (body['status'] == 'success') {
      print(body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['payload']['data']['token']);
      localStorage.setString(
          'user', json.encode(body['payload']['data']['user']));

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Credentials'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
