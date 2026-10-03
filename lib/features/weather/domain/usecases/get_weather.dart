import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Weather> call(String city) {
    return repository.getWeather(city);
  }
}
