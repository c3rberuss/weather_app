import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:weather_app/models/weather.dart';
import 'package:http/http.dart' as http;

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
      title: "Weather App",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Weather App"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<Weather>(
                future: clima,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Text("Nombre: ${snapshot.data.nombre}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Clima: ${snapshot.data.main}"),
                            Image.network(snapshot.data.icon)
                          ],
                        ),
                        Text('Temperatura: ${snapshot.data.temp}ºC')
                      ],
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
