import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.city,
    required super.temperature,
    required super.weatherCondition,
    required super.humidity,
    required super.windSpeed,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json,
    String city,
  ) {
    final current = json['current'] as Map<String, dynamic>;
    return WeatherModel(
      city: city,
      temperature: (current['temperature_2m'] as num).toDouble(),
      weatherCondition: current['Weather_code'].toString(),
      humidity: current['relative_humidity_2m'] as int,
      windSpeed: (current['wind_speed_10m']as num).toDouble(),
    );
  }
}
