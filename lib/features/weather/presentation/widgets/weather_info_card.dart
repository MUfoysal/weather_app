import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherInfoCard extends StatelessWidget {
  final Weather weather;

  const WeatherInfoCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              weather.city,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              weather.weatherCondition,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.water_drop),
                    const SizedBox(height: 4),
                    Text('${weather.humidity}%'),
                    const Text('Humidity'),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.air),
                    const SizedBox(height: 4),
                    Text(
                      '${weather.windSpeed.toStringAsFixed(1)} km/h',
                    ),
                    const Text('Wind'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}