import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Weather> getWeather(String city) async {
    final locationData = await remoteDataSource.getLocation(city);

    final results = locationData['results'] as List<dynamic>;

    if (results.isEmpty) {
      throw Exception('City not found');
    }

    final location = results.first as Map<String, dynamic>;

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