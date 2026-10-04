import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons_animated/weather_icons_animated.dart';

import 'package:weather_app/features/weather/domain/entities/daily_weather.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> forecast;

  const DailyForecast({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) return const SizedBox.shrink();

    var weekMin = forecast.first.minTemperature;
    var weekMax = forecast.first.maxTemperature;
    for (final day in forecast) {
      if (day.minTemperature < weekMin) weekMin = day.minTemperature;
      if (day.maxTemperature > weekMax) weekMax = day.maxTemperature;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${forecast.length}-Day Forecast',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < forecast.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
                _DailyRow(
                  item: forecast[i],
                  index: i,
                  isToday: i == 0,
                  weekMin: weekMin,
                  weekMax: weekMax,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyRow extends StatelessWidget {
  static const double _iconBoxSize = 44;
  static const double _iconSize = 28;
  static const double _tempWidth = 32;
  static const int _precipThreshold = 20;

  final DailyWeather item;
  final int index;
  final bool isToday;
  final double weekMin;
  final double weekMax;

  const _DailyRow({
    required this.item,
    required this.index,
    required this.isToday,
    required this.weekMin,
    required this.weekMax,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final scaler = MediaQuery.textScalerOf(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final locale = Localizations.localeOf(context).toString();

    final day = isToday ? 'Today' : DateFormat.E(locale).format(item.date);
    final high = '${item.maxTemperature.round()}°';
    final low = '${item.minTemperature.round()}°';
    final precipitation = '${item.precipitationProbability}%';
    final showPrecipitation = item.precipitationProbability >= _precipThreshold;

    final small = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: '$day, ${item.weatherCondition}, high $high, low $low, '
          '$precipitation chance of precipitation',
      child: Container(
        color: isToday ? scheme.primary.withAlpha(18) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                      color: isToday ? scheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (showPrecipitation) ...[
                        Icon(
                          Icons.water_drop,
                          size: 12,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          precipitation,
                          style: small?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          item.weatherCondition,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: small,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: _iconBoxSize,
              height: _iconBoxSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary.withAlpha(22),
              ),
              child: WeatherIcon(
                icon: WeatherIcons.fromOpenMeteoCode(
                  item.weatherCode,
                  isDay: true,
                ),
                size: _iconSize,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: scaler.scale(_tempWidth),
              child: Text(
                low,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: reduceMotion
                    ? Duration.zero
                    : Duration(milliseconds: 500 + index * 70),
                curve: Curves.easeOutCubic,
                builder: (_, progress, __) => _RangeBar(
                  low: item.minTemperature,
                  high: item.maxTemperature,
                  weekMin: weekMin,
                  weekMax: weekMax,
                  progress: progress,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: scaler.scale(_tempWidth),
              child: Text(
                high,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeBar extends StatelessWidget {
  static const double _height = 6;
  static const double _minFraction = 0.14;

  final double low;
  final double high;
  final double weekMin;
  final double weekMax;
  final double progress;

  const _RangeBar({
    required this.low,
    required this.high,
    required this.weekMin,
    required this.weekMax,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(_height);

    final span = weekMax - weekMin;
    final width =
        span <= 0 ? 1.0 : ((high - low) / span).clamp(_minFraction, 1.0).toDouble();
    final start =
        span <= 0 ? 0.0 : ((low - weekMin) / span).clamp(0.0, 1.0 - width).toDouble();

    return SizedBox(
      height: _height,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final trackWidth = constraints.maxWidth;

          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withAlpha(30),
                    borderRadius: radius,
                  ),
                ),
              ),
              Positioned(
                left: start * trackWidth,
                width: width * trackWidth * progress,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: LinearGradient(
                      colors: [
                        _temperatureColor(low),
                        _temperatureColor(high),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

const List<double> _colorStops = [0.0, 0.3, 0.55, 0.8, 1.0];
const List<Color> _colorValues = [
  Color(0xFF42A5F5),
  Color(0xFF26C6DA),
  Color(0xFFFFCA28),
  Color(0xFFFF7043),
  Color(0xFFE53935),
];

Color _temperatureColor(double celsius) {
  final t = ((celsius + 10) / 50).clamp(0.0, 1.0).toDouble();

  for (var i = 1; i < _colorStops.length; i++) {
    if (t <= _colorStops[i]) {
      final local = (t - _colorStops[i - 1]) / (_colorStops[i] - _colorStops[i - 1]);
      return Color.lerp(_colorValues[i - 1], _colorValues[i], local)!;
    }
  }

  return _colorValues.last;
}