import 'package:flutter/material.dart';

class WeatherWelcomeView extends StatelessWidget {
  const WeatherWelcomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_outlined,
              size: 64,
              color: Colors.blue.shade600,
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Discover Weather Anywhere',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Search for any city and explore its current weather, '
            'hourly forecast, and 7-day forecast.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FeatureItem(
                icon: Icons.thermostat,
                label: 'Current',
              ),
              const SizedBox(width: 20),
              _FeatureItem(
                icon: Icons.schedule,
                label: 'Hourly',
              ),
              const SizedBox(width: 20),
              _FeatureItem(
                icon: Icons.calendar_month,
                label: '7 Days',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 26,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}