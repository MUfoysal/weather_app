
import 'package:flutter/material.dart';
import 'package:weather_icons_animated/weather_icons_animated.dart';

import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard({
    super.key,
    required this.weather,
  });

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final current = weather.hourlyForecast.isEmpty
        ? null
        : weather.hourlyForecast.first;

    final isDay = current == null
        ? true
        : current.time.hour >= 6 && current.time.hour < 18;

    final weatherCode = current?.weatherCode;
    final precipitation = current?.precipitationProbability;

    final temperature = weather.temperature.round();
    final humidity = '${weather.humidity}%';
    final wind = '${weather.windSpeed.round()} km/h';

    final colors = _gradientFor(weatherCode, isDay);

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: '${weather.city}, '
          '$temperature degrees Celsius, '
          '${weather.weatherCondition}, '
          'humidity $humidity, '
          'wind $wind'
          '${precipitation == null ? '' : ', $precipitation% chance of rain'}',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.white.withAlpha(210),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      weather.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Temperature + Weather Icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                '$temperature',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 76,
                                  height: 0.95,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '°C',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white.withAlpha(210),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weather.weatherCondition,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withAlpha(220),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (weatherCode != null) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: WeatherIcon(
                        icon: WeatherIcons.fromOpenMeteoCode(
                          weatherCode,
                          isDay: isDay,
                        ),
                        size: 72,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 24),

              // Rain probability
              if (precipitation != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      size: 17,
                      color: Colors.white.withAlpha(210),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$precipitation% chance of rain',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha(220),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],

              // Weather statistics
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withAlpha(20),
                  border: Border.all(
                    color: Colors.white.withAlpha(28),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.water_drop_outlined,
                        value: humidity,
                        label: 'Humidity',
                      ),
                    ),
                    const _Divider(),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.air_outlined,
                        value: wind,
                        label: 'Wind',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: Colors.white.withAlpha(220),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: Text(
              value,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: double.infinity,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(180),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white.withAlpha(35),
    );
  }
}

const List<Color> _clearDay = [
  Color(0xFF3B8EE8),
  Color(0xFF2459C4),
];

const List<Color> _clearNight = [
  Color(0xFF1B2B5E),
  Color(0xFF0B1230),
];

const List<Color> _cloudDay = [
  Color(0xFF6B8AAB),
  Color(0xFF456180),
];

const List<Color> _cloudNight = [
  Color(0xFF3A4A5E),
  Color(0xFF1B2533),
];

const List<Color> _rainDay = [
  Color(0xFF5B7FA6),
  Color(0xFF34506F),
];

const List<Color> _rainNight = [
  Color(0xFF2C3E55),
  Color(0xFF141F30),
];

const List<Color> _snowDay = [
  Color(0xFF6F8CB0),
  Color(0xFF48638A),
];

const List<Color> _snowNight = [
  Color(0xFF3B4A63),
  Color(0xFF1F2A40),
];

const List<Color> _stormDay = [
  Color(0xFF4B4E6D),
  Color(0xFF2A2D43),
];

const List<Color> _stormNight = [
  Color(0xFF2A2D43),
  Color(0xFF14152A),
];

List<Color> _gradientFor(int? code, bool isDay) {
  if (code == null) {
    return isDay ? _clearDay : _clearNight;
  }

  if (code >= 95) {
    return isDay ? _stormDay : _stormNight;
  }

  if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
    return isDay ? _snowDay : _snowNight;
  }

  if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
    return isDay ? _rainDay : _rainNight;
  }

  if (code == 2 || code == 3 || code == 45 || code == 48) {
    return isDay ? _cloudDay : _cloudNight;
  }

  return isDay ? _clearDay : _clearNight;
}
