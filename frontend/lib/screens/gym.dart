import 'package:flutter/material.dart';
import 'package:gymapplication/api/api.dart';

import 'package:gymapplication/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gymapplication/screens/editGym.dart';

//widgets
import 'package:gymapplication/widgets/drawer.dart';
import 'package:gymapplication/widgets/navbar.dart';

import 'package:gymapplication/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "All Gyms",
    "image":
        "https://images.unsplash.com/photo-1558611848-73f7eb4001a1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGd5bXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
  }
};

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('gyms');
  var body = json.decode(response.body);
  print(body);
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
  final String location;
  final String contact;

  Data({this.id, this.name, this.location, this.contact});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      name: json['name'],
      location: json['location'],
      contact: json['contact'].toString(),
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

class Gym extends StatefulWidget {
  Gym({Key key}) : super(key: key);

  @override
  _GymState createState() => _GymState();
}

class _GymState extends State<Gym> {
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
          title: "Gyms",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Gym"),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  CardCategory(
                      title: "Gyms", pic: articlesCards["Content"]["image"]),
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
                                Navigator.pushReplacementNamed(
                                    context, '/addGym');
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
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.business),
                                        title: Text(data[index].name),
                                        subtitle: Text('Location: ' +
                                            data[index].location +
                                            '\n' +
                                            'Contact: ' +
                                            data[index].contact +
                                            '\n'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (_role == '1') ...[
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new EditGym(
                                                              list: data,
                                                              index: index),
                                                    ));
                                                  },
                                                  icon: Icon(Icons.edit)),
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
                                                              'gyms/' +
                                                                  data[index]
                                                                      .id,
                                                              tokenString);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content:
                                                            Text('Gym removed'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ));
                                                      Navigator.pushNamed(
                                                          context, '/gym');
                                                    } catch (e) {
                                                      print(e);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Cannot remove the Gym'),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ));
                                                    }
                                                  },
                                                  icon: Icon(Icons.delete)),
                                            ],
                                          ],
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
