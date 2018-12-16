import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:weather_app/models/weather.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/ui/header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

Future<Weather> _fetchWeather(double _lat, double _lon) async {
  final response = await http.get(
      "http://api.openweathermap.org/data/2.5/weather?lat=$_lat&lon=$_lon&appid=4b325b4e4218d260c1c418babe6443d4&units=metric&lang=es");

  if (response.statusCode == 200) {
    return Weather.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to load Weather");
  }
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;

  Location location = new Location();
  Future<Weather> clima;
  String error;

  void initState() {
    super.initState();

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    clima = _fetchWeather(
        currentLocation['latitude'], currentLocation['longitude']);

    initPlatformState();

    locationSubscription =
        location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        currentLocation = result;
        clima = _fetchWeather(
            currentLocation['latitude'], currentLocation['longitude']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: Scaffold(
          body: Column(
        children: <Widget>[
          Header(clima: clima),
          FutureBuilder<Weather>(
            future: clima,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.temperatureLow,
                          color: Color(0xFF74b9ff),
                        ),
                        title: Text("Minimum temperature"),
                        trailing: Text("${snapshot.data.tempMin.floor()}°C"),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Developed By"),
                                  content: Text("Josué Amaya - @c3rberuss"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.temperatureHigh,
                          color: Color(0xFFff7675),
                        ),
                        title: Text("Maximum temperature"),
                        trailing: Text("${snapshot.data.tempMax.floor()}°C"),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    locationSubscription.cancel();
  }

  void initPlatformState() async {
    Map<String, double> myLocation;

    try {
      myLocation = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        error = "Permiso Denegado";
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "Permisos Denegados - Preguntar al usuario";
      }

      myLocation = null;
    }

    setState(() {
      currentLocation = myLocation;
    });
  }
}
