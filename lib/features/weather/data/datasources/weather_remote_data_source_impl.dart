
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/core/error/weather_exception.dart';

import 'weather_remote_data_source.dart';

class WeatherRemoteDataSourceImpl
    implements WeatherRemoteDataSource {
  Future<http.Response> _get(Uri url) async {
    try {
      return await http
          .get(url)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on http.ClientException {
      throw const NetworkException();
    }
  }

  @override
  Future<Map<String, dynamic>> getLocation(String city) async {
    final url = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      {
        'name': city,
        'count': '1',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await _get(url);

    if (response.statusCode != 200) {
      throw const WeatherServiceException();
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getWeather(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': '$latitude',
        'longitude': '$longitude',
        'current':
            'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
        'hourly':
            'temperature_2m,weather_code,precipitation_probability',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
        'forecast_days': '7',
        'timezone': 'auto',
      },
    );

    final response = await _get(url);

    if (response.statusCode != 200) {
      throw const WeatherServiceException();
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
