import 'package:flutter/material.dart';
import 'package:gymapplication/api/api.dart';

import 'package:gymapplication/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymapplication/screens/chat.dart';
import 'package:gymapplication/screens/editAppointment.dart';
//widgets
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/widgets/navbar.dart';

import 'package:gymapplication/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View appointment",
    "image":
        "https://images.unsplash.com/photo-1642489069222-3b8f36c0e89e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=392&q=80",
  }
};

Future<List<Data>> fetchData() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);
  final response = await CallApi().getData('appointments');
  var body = json.decode(response.body);
  List today = [];
  if (response.statusCode == 200) {
    print(body['payload']['data']);

    List jsonResponse = body['payload']['data'];
    for (var i = 0; i < jsonResponse.length; i++) {
      DateTime dt =
          DateTime.parse(body['payload']['data'][i]['appointment_date']);
      // TimeOfDay _startTime = TimeOfDay(
      //     hour: int.parse(
      //         body['payload']['data'][i]['appointment_time'].split(":")[0]),
      //     minute: int.parse(
      //         body['payload']['data'][i]['appointment_time'].split(":")[1]));
      if (user['id'] == body['payload']['data'][i]['trainer_id'] ||
          user['id'] == body['payload']['data'][i]['customer_id']) {
        if (dt.day == DateTime.now().day) {
          today.add(body['payload']['data'][i]);
        }
      }
    }

    return today.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String id;

  final String status;
  final String trainer;
  final String customer;
  final String appointment_date;
  final String appointment_time;
  final String trainer_id;
  final String customer_id;

  Data(
      {this.id,
      this.trainer_id,
      this.customer_id,
      this.trainer,
      this.customer,
      this.status,
      this.appointment_date,
      this.appointment_time});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      trainer_id: json['trainer']['id'].toString(),
      customer_id: json['customer']['id'].toString(),
      trainer: json['trainer']['full_name'],
      customer: json['customer']['full_name'],
      appointment_date: json['appointment_date'],
      appointment_time: json['appointment_time'],
      status: json['status'].toString(),
    );
  }
}

Future<String> getUserInfo() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);

  int userType = user['role_id'];

  return userType.toString();
}

class Appointment extends StatefulWidget {
  Appointment({Key key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  Future<List<Data>> futureData;
  Future<String> userType;
  String _role;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    userType = getUserInfo();
    getUserInfo().then((value) => _role = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Appointments",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Appointment"),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
//
//
//

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Center(
                    child: FutureBuilder<String>(
                      future: userType,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          if (snapshot.data == "2") {
                            return RaisedButton(
                              textColor: NowUIColors.white,
                              color: NowUIColors.primary,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/addAppointment');
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  child: Icon(
                                    Icons.add,
                                    size: 32,
                                  )),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Text("");
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Center(
                    child: Text(
                      "Today's Appointments",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: NowUIColors.primary),
                    ),
                  ),

                  Center(
                    child: FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data> data = snapshot.data;
                          return Container(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      child: ListTile(
                                        leading:
                                            const Icon(Icons.calendar_today),
                                        title: Text(data[index].customer),
                                        subtitle: Column(
                                          children: <Widget>[
                                            SizedBox(height: 8.0),
                                            Text("Trainer: " +
                                                data[index].trainer +
                                                '\n'),
                                            data[index].status == '1'
                                                ? Text("Status: Physical \n")
                                                : Text("Status: Virtual \n"),
                                            Text('Date: ' +
                                                data[index].appointment_date +
                                                '\n'),
                                            Text('Time: ' +
                                                data[index].appointment_time +
                                                '\n'),
                                          ],
                                        ),
                                        trailing: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if ((data[index]
                                                      .appointment_date) ==
                                                  DateTime.now()
                                                      .toString()
                                                      .substring(0, 10)) ...[
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    print("appointment.dart");
                                                    print("patient");
                                                    print(data[index].customer);
                                                    print("doctor");
                                                    print(data[index].trainer);
                                                    if (_role == '2') {
                                                      Navigator.of(context).push(
                                                          new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new ChatPage(
                                                          username: data[index]
                                                              .customer_id,
                                                          receiver: data[index]
                                                              .trainer_id,
                                                          receiverName:
                                                              data[index]
                                                                  .trainer,
                                                        ),
                                                      ));
                                                    } else if (_role == '3') {
                                                      Navigator.of(context).push(
                                                          new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new ChatPage(
                                                          username: data[index]
                                                              .trainer_id,
                                                          receiver: data[index]
                                                              .customer_id,
                                                          receiverName:
                                                              data[index]
                                                                  .customer,
                                                        ),
                                                      ));
                                                    }
                                                  },
                                                  icon: Icon(Icons.chat,
                                                      color: Colors.pink),
                                                  label: Text("Chat"),
                                                )
                                              ],
                                              OutlinedButton.icon(
                                                onPressed: () async {
                                                  // Respond to button press
                                                  try {
                                                    SharedPreferences
                                                        localStorage =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    var tokenString =
                                                        localStorage
                                                            .getString('token');
//                                                      data.removeAt(index);
                                                    await CallApi().deleteData(
                                                        'appointments/' +
                                                            data[index].id,
                                                        tokenString);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Appointment removed'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                    Navigator.pushNamed(context,
                                                        '/appointment');
                                                  } catch (e) {
                                                    print(e);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Cannot remove the Appointment'),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ));
                                                  }
                                                },
                                                icon: Icon(Icons.remove,
                                                    color: Colors.red),
                                                label: Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        isThreeLine: true,
                                      ),
                                    );
                                  }));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
