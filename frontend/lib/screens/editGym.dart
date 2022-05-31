import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:gymapplication/constants/Theme.dart';

//widgets
import 'package:gymapplication/widgets/navbar.dart';
import 'package:gymapplication/widgets/input.dart';
import 'package:gymapplication/screens/login.dart';
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditGym extends StatefulWidget {
  List list;
  int index;
  EditGym({this.index, this.list});
  @override
  _EditGymState createState() => _EditGymState();
}

class _EditGymState extends State<EditGym> {
  bool _isLoading = false;

  TextEditingController name;
  TextEditingController contact;
  TextEditingController location;

  final double height = window.physicalSize.height;
  @override
  void initState() {
    name = new TextEditingController(text: widget.list[widget.index].name);
    contact =
        new TextEditingController(text: widget.list[widget.index].contact);
    location =
        new TextEditingController(text: widget.list[widget.index].location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          transparent: true,
          title: "",
          reverseTextcolor: true,
        ),
        extendBodyBehindAppBar: true,
        drawer: NowDrawer(currentPage: "Gym"),
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
                                        child: Text("Edit Gym",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Name",
                                          onChanged: (value) {},
                                          controller: name,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Contact",
                                          onChanged: (value) {},
                                          controller: contact,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Location",
                                          onChanged: (value) {},
                                          controller: location,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () async {
                                        // Respond to button press
                                        var data = {
                                          'name': name.text,
                                          'contact': contact.text,
                                          'location': location.text,
                                        };

                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        var tokenString =
                                            localStorage.getString('token');
                                        String id =
                                            widget.list[widget.index].id;

                                        var res = await CallApi().editData(
                                            data, 'gyms/' + id, tokenString);
                                        var body = json.decode(res.body);
                                        if (body['status'] == 'success') {
                                          Navigator.pushReplacementNamed(
                                              context, '/gym');
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Gym cannot be Edited'),
                                            backgroundColor: Colors.redAccent,
                                          ));
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Edit",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: InkWell(
                                          child: Text(
                                            "Back",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14.0),
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/gym');
                                          },
                                        )),
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
}
