class DailyWeather {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final String weatherCondition;
  final int weatherCode;
  final int precipitationProbability;

  const DailyWeather({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCondition,
    required this.weatherCode,
    required this.precipitationProbability,
  });
}