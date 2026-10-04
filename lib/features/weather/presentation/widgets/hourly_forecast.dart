import 'package:flutter/material.dart';

import 'package:weather_app/features/weather/domain/entities/hourly_weather.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> forecast;

  const HourlyForecast({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next Hours',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length > 8 ? 8 : forecast.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = forecast[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item.time.hour.toString().padLeft(2, '0')}:00',
                      ),

                      const SizedBox(height: 8),

                      Icon(
                        _getWeatherIcon(item.weatherCondition),
                        size: 30,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${item.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${item.precipitationProbability}%',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.contains('Thunderstorm')) {
      return Icons.thunderstorm;
    }

    if (condition.contains('Rain') ||
        condition.contains('Drizzle')) {
      return Icons.umbrella;
    }

    if (condition.contains('Snow')) {
      return Icons.ac_unit;
    }

    if (condition.contains('Fog')) {
      return Icons.foggy;
    }

    if (condition.contains('Cloud')) {
      return Icons.cloud;
    }

    return Icons.wb_sunny;
  }
}