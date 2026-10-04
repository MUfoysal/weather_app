class HourlyWeather {
  final DateTime time;
  final double temperature;
  final String weatherCondition;
  final int weatherCode;
  final int precipitationProbability;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCondition,
    required this.weatherCode,
    required this.precipitationProbability,
  });
}
