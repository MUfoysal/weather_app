
import 'package:flutter/material.dart';
import 'package:weather_icons_animated/weather_icons_animated.dart';

class WeatherWelcomeView extends StatefulWidget {
  const WeatherWelcomeView({
    super.key,
    this.onCitySelected,
  });

  final ValueChanged<String>? onCitySelected;

  @override
  State<WeatherWelcomeView> createState() => _WeatherWelcomeViewState();
}

class _WeatherWelcomeViewState extends State<WeatherWelcomeView>
    with SingleTickerProviderStateMixin {
  static const List<String> _suggestions = [
    'Dhaka',
    'Tokyo',
    'London',
    'New York',
  ];

  late final AnimationController _animationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MediaQuery.disableAnimationsOf(context)) {
      _animationController.value = 1;
      return;
    }

    if (!_animationController.isAnimating &&
        !_animationController.isCompleted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final onCitySelected = widget.onCitySelected;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          _Reveal(
            animation: _animationController,
            begin: 0,
            end: 0.65,
            child: Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer,
              ),
              child: WeatherIcon(
                icon: WeatherIcons.fromOpenMeteoCode(
                  0,
                  isDay: true,
                ),
                size: 88,
              ),
            ),
          ),

          const SizedBox(height: 28),

          _Reveal(
            animation: _animationController,
            begin: 0.15,
            end: 0.75,
            child: Text(
              'Weather, anywhere.',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 10),

          _Reveal(
            animation: _animationController,
            begin: 0.25,
            end: 0.85,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Search any city to see current conditions, '
                'hourly weather, and the week ahead.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          _Reveal(
            animation: _animationController,
            begin: 0.35,
            end: 0.95,
            child: Row(
              children: const [
                Expanded(
                  child: _FeatureTile(
                    icon: Icons.thermostat_outlined,
                    title: 'Current',
                    caption: 'Live now',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _FeatureTile(
                    icon: Icons.schedule_outlined,
                    title: 'Hourly',
                    caption: 'Hour by hour',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _FeatureTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Daily',
                    caption: '7-day forecast',
                  ),
                ),
              ],
            ),
          ),

          if (onCitySelected != null) ...[
            const SizedBox(height: 28),

            _Reveal(
              animation: _animationController,
              begin: 0.45,
              end: 1,
              child: Column(
                children: [
                  Text(
                    'Try a city',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final city in _suggestions)
                        ActionChip(
                          label: Text(city),
                          avatar: const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                          ),
                          shape: const StadiumBorder(),
                          onPressed: () => onCitySelected(city),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.begin,
    required this.end,
    required this.child,
  });

  final Animation<double> animation;
  final double begin;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curve = Interval(
      begin,
      end,
      curve: Curves.easeOutCubic,
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (_, child) {
        final value = curve.transform(animation.value);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.caption,
  });

  final IconData icon;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.surfaceContainerHighest.withAlpha(120),
        border: Border.all(
          color: scheme.outlineVariant.withAlpha(120),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: scheme.primary,
          ),
          const SizedBox(height: 7),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}