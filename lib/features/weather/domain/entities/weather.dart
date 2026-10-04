import 'package:weather_app/features/weather/domain/entities/daily_weather.dart';
import 'package:weather_app/features/weather/domain/entities/hourly_weather.dart';

class Weather {
  final String city;
  final double temperature;
  final String weatherCondition;
  final int humidity;
  final double windSpeed;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;

  const Weather({
    required this.city,
    required this.temperature,
    required this.weatherCondition,
    required this.humidity,
    required this.windSpeed,
    required this.hourlyForecast,
    required this.dailyForecast,

  });
}
