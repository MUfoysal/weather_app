import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/di/weather_dependencies.dart';

void main() {
  test('should fetch weather for Dhaka', () async {
    final dependencies = WeatherDependencies();

    final weather = await dependencies.getWeather('Dhaka');

    print('City: ${weather.city}');
    print('Temperature: ${weather.temperature}°C');
    print('Condition: ${weather.weatherCondition}');
    print('Humidity: ${weather.humidity}%');
    print('Wind Speed: ${weather.windSpeed} km/h');

    expect(weather.city, isNotEmpty);
    expect(weather.temperature, isA<double>());
    expect(weather.weatherCondition, isNotEmpty);
    expect(weather.humidity, isA<int>());
    expect(weather.windSpeed, isA<double>());
  });
}