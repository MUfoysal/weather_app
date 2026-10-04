import 'package:flutter/material.dart';

class WeatherErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const WeatherErrorView({super.key,
  required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.error_outline,
        size: 48,
        ),
        const SizedBox(height: 12,),
        const Text(
          'Something went wrong.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8,),
        const Text('Please try again.'),
        const SizedBox(height: 16,),

        ElevatedButton(onPressed: onRetry,
         child: const Text('Retry'),),
      ],
    );
  }
}
