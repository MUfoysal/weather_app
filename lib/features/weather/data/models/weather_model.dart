import 'package:weather_app/core/utils/weather_code_mapper.dart';
import 'package:weather_app/features/weather/domain/entities/daily_weather.dart';
import 'package:weather_app/features/weather/domain/entities/hourly_weather.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.city,
    required super.temperature,
    required super.weatherCondition,
    required super.humidity,
    required super.windSpeed,
    required super.hourlyForecast,
    required super.dailyForecast,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json,
    String city,
  ) {
    final current = json['current'] as Map<String, dynamic>;

    final hourly = json['hourly'] as Map<String, dynamic>;
    final hourlyTimes = hourly['time'] as List<dynamic>;
    final hourlyTemperatures =
        hourly['temperature_2m'] as List<dynamic>;
    final hourlyWeatherCodes =
        hourly['weather_code'] as List<dynamic>;
    final hourlyPrecipitation =
        hourly['precipitation_probability'] as List<dynamic>;

    final hourlyForecast = List.generate(
      hourlyTimes.length,
      (index) {
        return HourlyWeather(
          time: DateTime.parse(hourlyTimes[index] as String),
          temperature:
              (hourlyTemperatures[index] as num).toDouble(),
          weatherCondition: WeatherCodeMapper.getCondition(
            hourlyWeatherCodes[index] as int,
          ),
          precipitationProbability:
              hourlyPrecipitation[index] as int,
        );
      },
    );

    final daily = json['daily'] as Map<String, dynamic>;
    final dailyTimes = daily['time'] as List<dynamic>;
    final dailyMaxTemperatures =
        daily['temperature_2m_max'] as List<dynamic>;
    final dailyMinTemperatures =
        daily['temperature_2m_min'] as List<dynamic>;
    final dailyWeatherCodes =
        daily['weather_code'] as List<dynamic>;
    final dailyPrecipitation =
        daily['precipitation_probability_max'] as List<dynamic>;

    final dailyForecast = List.generate(
      dailyTimes.length,
      (index) {
        return DailyWeather(
          date: DateTime.parse(dailyTimes[index] as String),
          maxTemperature:
              (dailyMaxTemperatures[index] as num).toDouble(),
          minTemperature:
              (dailyMinTemperatures[index] as num).toDouble(),
          weatherCondition: WeatherCodeMapper.getCondition(
            dailyWeatherCodes[index] as int,
          ),
          precipitationProbability:
              dailyPrecipitation[index] as int,
        );
      },
    );

    return WeatherModel(
      city: city,
      temperature:
          (current['temperature_2m'] as num).toDouble(),
      weatherCondition: WeatherCodeMapper.getCondition(
        current['weather_code'] as int,
      ),
      humidity: current['relative_humidity_2m'] as int,
      windSpeed:
          (current['wind_speed_10m'] as num).toDouble(),
      hourlyForecast: hourlyForecast,
      dailyForecast: dailyForecast,
    );
  }
}