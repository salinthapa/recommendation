import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:gymapplication/constants/Theme.dart';

//widgets
import 'package:gymapplication/widgets/navbar.dart';
import 'package:gymapplication/widgets/input.dart';

import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('users');
  var body = json.decode(response.body);
  List trainers = [];

  if (response.statusCode == 200) {
    List jsonResponse = body['payload']['data'];
    for (var i = 0; i < jsonResponse.length; i++) {
      if (body['payload']['data'][i]['role_id'] == 3) {
        trainers.add(body['payload']['data'][i]);
      }
    }

    return trainers.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String id;
  final String name;

  Data({this.id, this.name});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      name: json['full_name'],
    );
  }
}

class AddAppointment extends StatefulWidget {
  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  Data _currentUser;
  bool _isLoading = false;
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  TextEditingController date = TextEditingController();
  bool status = false;

  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          transparent: true,
          title: "",
          reverseTextcolor: true,
        ),
        extendBodyBehindAppBar: true,
        drawer: NowDrawer(currentPage: "Appointment"),
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
                                        child: Text("Add Appointment",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<Data>>(
                                          future: futureData,
                                          // ignore: missing_return
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Center(
                                                  child: DropdownButton<Data>(
                                                value: null,
                                                isDense: true,
                                                items: snapshot.data
                                                    .map((user) =>
                                                        DropdownMenuItem<Data>(
                                                          child:
                                                              Text(user.name),
                                                          value: user,
                                                        ))
                                                    .toList(),

                                                onChanged: (Data data) {
                                                  setState(() {
                                                    _currentUser = data;
                                                  });
                                                },
                                                isExpanded: false,
                                                //value: _currentUser,
                                                hint: Text(_currentUser == null
                                                    ? "Select trainer"
                                                    : _currentUser.name),
                                              ));
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Center(
                                            child: TextField(
                                          readOnly: true,
                                          controller: date,
                                          decoration:
                                              InputDecoration(hintText: 'Date'),
                                          onTap: () async {
                                            var dates = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            date.text = dates
                                                .toString()
                                                .substring(0, 10);
                                          },
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: _selectTime,
                                                child: Text('Time'),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${_time.format(context)}\n',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(child: Text("Online/Physical")),
                                      Center(
                                        child: Switch(
                                          value: status,
                                          onChanged: (value) {
                                            setState(() {
                                              status = value;
                                              print(status);
                                            });
                                          },
                                          activeTrackColor:
                                              Colors.lightGreenAccent,
                                          activeColor: Colors.green,
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
                                        appointmentForm();
                                      },
                                      shape: RoundedRectangleBorder(),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Add",
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
                                          child: Text("Back"),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/appointment');
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

  void appointmentForm() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    String formatTimeOfDay(TimeOfDay tod) {
      final now = new DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      final format = DateFormat.jm();
      return format.format(dt);
    }

    String tame = formatTimeOfDay(_time);

    var data = {
      'trainer_id': _currentUser.id,
      'customer_id': user['id'],
      'appointment_date': date.text,
      'appointment_time': tame,
      'status': status
    };

    var tokenString = localStorage.getString('token');
    var res =
        await CallApi().postDataWithToken(data, 'appointments', tokenString);

    var body = json.decode(res.body);
    print(body);

    if (body['status'] == 'success') {
      Navigator.pushReplacementNamed(context, '/appointment');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment cannot be added'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
