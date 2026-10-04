import 'package:flutter/material.dart';

import 'package:weather_app/features/weather/di/weather_dependencies.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/weather_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/daily_forecast.dart';
import 'package:weather_app/features/weather/presentation/widgets/hourly_forecast.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_error_view.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_info_card.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_welcome_view.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({
    super.key,
    this.dependencies,
  });

  final WeatherDependencies? dependencies;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  static const double _maxContentWidth = 640;

  late final _WeatherController _controller;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = _WeatherController(
      widget.dependencies ?? WeatherDependencies(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _submit(String value) {
    FocusScope.of(context).unfocus();
    _controller.search(value);
  }

  Widget _buildBody() {
    final weather = _controller.weather;

    return switch (_controller.state) {
      WeatherState.initial => const KeyedSubtree(
          key: ValueKey('initial'),
          child: WeatherWelcomeView(),
        ),
      WeatherState.loading when weather == null => const KeyedSubtree(
          key: ValueKey('loading'),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      WeatherState.loading || WeatherState.success => weather == null
          ? const SizedBox.shrink(key: ValueKey('empty'))
          : KeyedSubtree(
              key: const ValueKey('content'),
              child: _WeatherContent(weather: weather),
            ),
      WeatherState.error => KeyedSubtree(
          key: const ValueKey('error'),
          child: WeatherErrorView(onRetry: _controller.retry),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return RefreshIndicator(
                  onRefresh: _controller.retry,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      _SearchField(
                        controller: _textController,
                        isLoading: _controller.isLoading,
                        onSubmit: _submit,
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        layoutBuilder: (current, previous) => Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            ...previous,
                             ?current,
                          ],
                        ),
                        child: _buildBody(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherController extends ChangeNotifier {
  _WeatherController(this._dependencies);

  final WeatherDependencies _dependencies;

  WeatherState _state = WeatherState.initial;
  Weather? _weather;
  String? _lastCity;
  int _requestId = 0;
  bool _disposed = false;

  WeatherState get state => _state;
  Weather? get weather => _weather;
  bool get isLoading => _state == WeatherState.loading;

  Future<void> search(String city) async {
    final query = city.trim();
    if (query.isEmpty) return;

    final requestId = ++_requestId;
    _lastCity = query;
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final result = await _dependencies.getWeather(query);
      if (_disposed || requestId != _requestId) return;
      _weather = result;
      _state = WeatherState.success;
    } catch (_) {
      if (_disposed || requestId != _requestId) return;
      _state = WeatherState.error;
    }

    notifyListeners();
  }

  Future<void> retry() {
    final city = _lastCity;
    if (city == null) return Future.value();
    return search(city);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      onSubmitted: onSubmit,
      decoration: InputDecoration(
        hintText: 'Search city',
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.arrow_forward_rounded),
                onPressed: () => onSubmit(controller.text),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeatherInfoCard(weather: weather),
        const SizedBox(height: 24),
        HourlyForecast(forecast: weather.hourlyForecast),
        const SizedBox(height: 24),
        DailyForecast(forecast: weather.dailyForecast),
      ],
    );
  }
}