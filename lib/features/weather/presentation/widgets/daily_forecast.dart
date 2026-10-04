import 'package:flutter/material.dart';

import 'package:weather_app/features/weather/domain/entities/daily_weather.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> forecast;

  const DailyForecast({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '7-Day Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        ...forecast.map(
          (item) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      _formatDate(item.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Icon(
                    _getWeatherIcon(item.weatherCondition),
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      item.weatherCondition,
                    ),
                  ),

                  Text(
                    '${item.maxTemperature.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '${item.minTemperature.toStringAsFixed(0)}°',
                  ),

                  const SizedBox(width: 12),

                  Text(
                    '${item.precipitationProbability}%',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
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