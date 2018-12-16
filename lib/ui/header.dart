import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/ui/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:core';

class Header extends StatelessWidget {
  final Future<Weather> clima;
  static const icons = {
    "01d": "assets/images/soleado_05.png",
    "01n": "assets/images/noche_despejada_01.png",
    "02d": "assets/images/nublado_dia_01.png",
    "02n": "assets/images/nublado_noche_01.png",
    "03d": "assets/images/nubes_01.png",
    "03n": "assets/images/nubes_01.png",
    "04d": "assets/images/nubes_02.png",
    "04n": "assets/images/nubes_02.png",
    "09d": "assets/images/lluvia_01.png",
    "09n": "assets/images/lluvia_01.png",
    "10d": "assets/images/lluvia_06.png",
    "10n": "assets/images/lluvia_03.png",
    "11d": "assets/images/tormenta_01.png",
    "11n": "assets/images/tormenta_01.png",
    "13d": "assets/images/lluvia_05.png",
    "13n": "assets/images/lluvia_05.png",
    "50d": "assets/images/viento_01.png",
    "50n": "assets/images/viento_01.png",
  };

  const Header({Key key, this.clima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0984e3) /*Color(0xFF81ecec)*/, Color(0xFF74b9ff)],
          begin: FractionalOffset(0.9, 0.9),
          end: FractionalOffset(0.1, 0.1),
        ),
      ),
      height: screen.height * 0.75,
      width: screen.width,
      child: Padding(
        padding:
            EdgeInsets.only(top: 50, right: 20.0, left: 20.0, bottom: 10.0),
        child: FutureBuilder(
          future: clima,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  AutoSizeText(
                    "${snapshot.data.name}".toUpperCase(),
                    style: Styles.city,
                    maxLines: 1,
                  ),
                  Text(
                    "${snapshot.data.main}",
                    style: Styles.pron,
                  ),
                  Text(
                    "${snapshot.data.temp.floor()}°",
                    style: Styles.temp,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        icons["${snapshot.data.icon}"],
                        height: screen.width / 2,
                        width: screen.width / 2,
                        alignment: Alignment.center,
                      ),
                    ],
                  )
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator()],
            );
          },
        ),
      ),
    );
  }
}
