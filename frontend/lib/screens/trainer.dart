import 'package:flutter/material.dart';
import 'package:gymapplication/api/api.dart';

import 'package:gymapplication/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/widgets/navbar.dart';

import 'package:gymapplication/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View trainer",
    "image":
        "https://images.unsplash.com/photo-1619361728853-2542f3864532?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8dHJhaW5lcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
  }
};

Future<String> getUserInfo() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);

  int userType = user['role_id'];

  return userType.toString();
}

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('users');
  var body = json.decode(response.body);
  List trainers = [];
  print(body);

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
  final String full_name;
  final String first_name;
  final String last_name;
  final String phone;
  final String email;
  final String qualification;
  final String password;
  final String gym_id;

  Data(
      {this.id,
      this.full_name,
      this.phone,
      this.email,
      this.qualification,
      this.first_name,
      this.last_name,
      this.password,
      this.gym_id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'].toString(),
        full_name: json['full_name'],
        phone: json['phone'],
        email: json['email'],
        qualification: json['qualification'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        password: json['password'],
        gym_id: json['gym']['name']);
  }
}

class Trainer extends StatefulWidget {
  Trainer({Key key}) : super(key: key);

  @override
  _TrainerState createState() => _TrainerState();
}

class _TrainerState extends State<Trainer> {
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
          title: "Trainers",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Trainer"),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  CardCategory(
                      title: "Trainers",
                      pic: articlesCards["Content"]["image"]),
                  Center(
                    child: FutureBuilder<String>(
                      future: userType,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          if (snapshot.data == "1") {
                            return RaisedButton(
                              textColor: NowUIColors.white,
                              color: NowUIColors.primary,
                              onPressed: () {
                                // Respond to button press
                                Navigator.pushReplacementNamed(
                                    context, '/addTrainer');
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
                        // By default show a loading spinner.
                        return Text("");
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
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
                                        leading: const Icon(Icons.person),
                                        title: Text(data[index].full_name),
                                        subtitle: Text('Email: ' +
                                            data[index].email +
                                            '\n' +
                                            'Phone : ' +
                                            data[index].phone +
                                            '\n' +
                                            'Qualification: ' +
                                            data[index].qualification +
                                            '\n' +
                                            'gym_id: ' +
                                            data[index].gym_id +
                                            '\n'),
                                        trailing: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if (_role == '1') ...[
                                                IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        SharedPreferences
                                                            localStorage =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        var tokenString =
                                                            localStorage
                                                                .getString(
                                                                    'token');

                                                        await CallApi()
                                                            .deleteData(
                                                                'users/' +
                                                                    data[index]
                                                                        .id,
                                                                tokenString);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'Trainer removed'),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ));
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/trainer');
                                                      } catch (e) {
                                                        print(e);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'Cannot remove the trainer'),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                        ));
                                                      }
                                                    },
                                                    icon: Icon(Icons.delete)),
                                              ],
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
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
