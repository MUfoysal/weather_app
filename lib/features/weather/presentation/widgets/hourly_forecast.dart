import 'package:flutter/material.dart';

import 'package:weather_icons_animated/weather_icons_animated.dart';

import 'package:weather_app/features/weather/domain/entities/hourly_weather.dart';

class HourlyForecast extends StatelessWidget {
  static const int maxItems = 8;
  static const double _baseHeight = 165;
  static const double _cardWidth = 72;

  final List<HourlyWeather> forecast;

  const HourlyForecast({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) {
      return const SizedBox.shrink();
    }

    final items = forecast.take(maxItems).toList(growable: false);

    final height = MediaQuery.textScalerOf(context).scale(_baseHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next Hours',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, index) => _HourlyCard(
              item: items[index],
              width: _cardWidth,
            ),
          ),
        ),
      ],
    );
  }
}

class _HourlyCard extends StatelessWidget {
  final HourlyWeather item;
  final double width;

  const _HourlyCard({
    required this.item,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final time = _formatTime(item.time);

    final temperature = '${item.temperature.round()}°';

    final precipitation = '${item.precipitationProbability}%';

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: '$time, $temperature, $precipitation chance of precipitation',
      child: SizedBox(
        width: width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: 36,
                  height: 36,
                  child: WeatherIcon(
                    icon: WeatherIcons.fromOpenMeteoCode(
                      item.weatherCode,
                      isDay: item.time.hour >= 6 &&
                          item.time.hour < 18,
                    ),
                    size: 36,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  temperature,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(precipitation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;

    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour $period';
  }
}