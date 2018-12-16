class Weather {
  final String main;
  final String description;
  final String icon;
  final String name;
  final dynamic temp;
  final dynamic pressure;
  final dynamic humidity;
  final dynamic tempMin;
  final dynamic tempMax;
  final dynamic windSpeed;

  Weather(
      {this.main,
      this.description,
      this.icon,
      this.temp,
      this.pressure,
      this.humidity,
      this.tempMin,
      this.tempMax,
      this.windSpeed,
      this.name});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        main: json['weather'][0]['main'],
        description: json['weather'][0]['description'],
        icon: json['weather'][0]['icon'],
        name: json['name'],
        temp: json['main']['temp'],
        pressure: json['main']['pressure'],
        humidity: json['main']['humidity'],
        tempMin: json['main']['temp_min'],
        tempMax: json['main']['temp_max'],
        windSpeed: json['wind']['speed']);
  }
}
