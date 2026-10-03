import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';

class WeatherDependencies {
  late final WeatherRemoteDataSource remoteDataSource;
  late final WeatherRepository repository;
  late final GetWeather getWeather;

  WeatherDependencies() {
    remoteDataSource = WeatherRemoteDataSourceImpl();
    repository = WeatherRepositoryImpl(remoteDataSource);
    getWeather = GetWeather(repository);
  }
}
