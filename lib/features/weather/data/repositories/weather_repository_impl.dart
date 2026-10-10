
import 'package:weather_app/core/error/weather_exception.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this.remoteDataSource);

  final WeatherRemoteDataSource remoteDataSource;

  @override
  Future<Weather> getWeather(String city) async {
    final locationData = await remoteDataSource.getLocation(city);

    final results = locationData['results'];

    if (results == null) {
      throw const CityNotFoundException();
    }

    if (results is! List) {
      throw const WeatherServiceException();
    }

    if (results.isEmpty) {
      throw const CityNotFoundException();
    }

    final location = results.first;

    if (location is! Map<String, dynamic>) {
      throw const WeatherServiceException();
    }

    final latitude = (location['latitude'] as num).toDouble();
    final longitude = (location['longitude'] as num).toDouble();
    final cityName = location['name'] as String;

    final weatherData = await remoteDataSource.getWeather(
      latitude,
      longitude,
    );

    return WeatherModel.fromJson(weatherData, cityName);
  }
}
