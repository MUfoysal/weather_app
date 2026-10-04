import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/di/weather_dependencies.dart';

void main() {
  test('should fetch weather for Dhaka', () async {
    final dependencies = WeatherDependencies();

    final weather = await dependencies.getWeather('Dhaka');

    expect(weather.city, isNotEmpty);
    expect(weather.temperature, isA<double>());
    expect(weather.weatherCondition, isNotEmpty);
    expect(weather.humidity, isA<int>());
    expect(weather.windSpeed, isA<double>());

    expect(weather.hourlyForecast, isNotEmpty);
    expect(weather.dailyForecast, isNotEmpty);
    expect(weather.dailyForecast.length, 7);

    expect(
      weather.hourlyForecast.first.precipitationProbability,
      inInclusiveRange(0, 100),
    );

    expect(
      weather.dailyForecast.first.precipitationProbability,
      inInclusiveRange(0, 100),
    );
  });
}