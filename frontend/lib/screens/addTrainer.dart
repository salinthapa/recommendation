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

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('gyms');
  var body = json.decode(response.body);

  if (response.statusCode == 200) {
    List jsonResponse = body['payload']['data'];

    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
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
      name: json['name'],
    );
  }
}

class AddTrainer extends StatefulWidget {
  @override
  _AddTrainerState createState() => _AddTrainerState();
}

class _AddTrainerState extends State<AddTrainer> {
  bool _checkboxValue = false;
  final _formKey = GlobalKey<FormState>();
  bool _autovaliodate = false;
  bool _isLoading = false;

  final double height = window.physicalSize.height;
  Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Data _currentUser;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController qualification = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NowDrawer(currentPage: "Trainer"),
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Add Trainers",
          rightOptions: false,
        ),
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
                                        child: Text("Add Trainers",
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
                                          placeholder: "First Name",
                                          onChanged: (value) {},
                                          controller: firstname,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Last Name",
                                          onChanged: (value) {},
                                          controller: lastname,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          num: TextInputType.phone,
                                          placeholder: "Phone Number",
                                          onChanged: (value) {},
                                          controller: phone,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Qualification",
                                          onChanged: (value) {},
                                          controller: qualification,
                                        ),
                                      ),
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
                                                    .map((gym) =>
                                                        DropdownMenuItem<Data>(
                                                          child: Text(gym.name),
                                                          value: gym,
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
                                                    ? "Select Gym"
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
                                        child: Input(
                                          placeholder: "Email",
                                          onChanged: (value) {},
                                          controller: username,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Password",
                                          onChanged: (value) {},
                                          pass: true,
                                          controller: password,
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
                                        addTrainerForm();
                                      },
                                      shape: RoundedRectangleBorder(),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Add Trainer",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
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

  void addTrainerForm() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'first_name': firstname.text,
      'last_name': lastname.text,
      'phone': phone.text,
      'email': username.text,
      'password': password.text,
      'password_confirmation': password.text,
      'qualification': qualification.text,
      'gym_id': _currentUser.id,
      'role_id': 3,
    };
    print(data);
    var res = await CallApi().postDataWithoutToken(data, 'register');
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == 'success') {
//      print(body);
//      SharedPreferences localStorage = await SharedPreferences.getInstance();
//      localStorage.setString('token', body['token']);
//      localStorage.setString('user', json.encode(body['user']));

      Navigator.pushReplacementNamed(context, '/trainer');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration Cannot be Completed'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
