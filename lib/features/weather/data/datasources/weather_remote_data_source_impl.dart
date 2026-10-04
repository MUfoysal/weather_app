import 'dart:convert';

import 'package:http/http.dart' as http;

import 'weather_remote_data_source.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getLocation(String city) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search'
      '?name=$city&count=1&language=en&format=json',
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Faild to fetch location');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  @override
Future<Map<String, dynamic>> getWeather(
  double latitude,
  double longitude,
) async {
  final url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast'
    '?latitude=$latitude'
    '&longitude=$longitude'
    '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m'
    '&hourly=temperature_2m,weather_code,precipitation_probability'
    '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
    '&forecast_days=7'
    '&timezone=auto',
  );

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch weather');
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}
}
