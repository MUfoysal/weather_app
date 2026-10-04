import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/di/weather_dependencies.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/weather_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_error_view.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_info_card.dart';
import 'package:weather_app/features/weather/presentation/widgets/hourly_forecast.dart';
import 'package:weather_app/features/weather/presentation/widgets/daily_forecast.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherDependencies dependencies = WeatherDependencies();

  final TextEditingController cityController = TextEditingController();

  WeatherState state = WeatherState.initial;

  Weather? weather;

  Future<void> searchWeather(String city) async {
    setState(() {
      state = WeatherState.loading;
    });

    try {
      final result = await dependencies.getWeather(city);

      setState(() {
        weather = result;
        state = WeatherState.success;
      });
    } catch (e) {
      setState(() {
        state = WeatherState.error;
      });
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      TextField(
        controller: cityController,
        decoration: const InputDecoration(
          hintText: 'Enter city name',
          border: OutlineInputBorder(),
        ),
      ),

      const SizedBox(height: 16),

      ElevatedButton(
        onPressed: () {
          final city = cityController.text.trim();

          if (city.isEmpty) {
            return;
          }

          searchWeather(city);
        },
        child: const Text('Search'),
      ),

      const SizedBox(height: 24),

      if (state == WeatherState.loading)
        const CircularProgressIndicator(),

      if (state == WeatherState.success && weather != null) ...[
        WeatherInfoCard(
          weather: weather!,
        ),

        const SizedBox(height: 24),

        HourlyForecast(
          forecast: weather!.hourlyForecast,
        ),
        const SizedBox(height: 24,),

        DailyForecast(forecast: weather!.dailyForecast,),

        const SizedBox(height: 25,),
      ],

      if (state == WeatherState.error)
        WeatherErrorView(
          onRetry: () {
            final city = cityController.text.trim();

            if (city.isEmpty) {
              return;
            }

            searchWeather(city);
          },
        ),
    ],
  ),
),
    );
  }
}