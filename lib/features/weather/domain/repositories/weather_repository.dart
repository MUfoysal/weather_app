import 'package:weather_app/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
}
