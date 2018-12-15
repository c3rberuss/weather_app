import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;

  Location location = new Location();
  String error;

  void initState() {
    super.initState();

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();

    locationSubscription =
        location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        currentLocation = result;
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
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Latitude: ' + currentLocation["latitude"].toString()),
              Text('Longitude: ' + currentLocation["longitude"].toString())
            ],
          ),
        ),
      ),
    );
  }

  void initPlatformState() async {
    Map<String, double> my_location;

    try {
      my_location = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        error = "Permiso Denegado";
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "Permisos Denegados - Preguntar al usuario";
      }

      my_location = null;
    }

    setState(() {
      currentLocation = my_location;
    });
  }
}
