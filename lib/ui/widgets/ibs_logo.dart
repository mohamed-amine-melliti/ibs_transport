import 'package:flutter/material.dart';
import 'package:sossoldi/ui/login_page.dart'; // Assuming Sizes is defined here or in a common place

class IBSLogo extends StatelessWidget {
  const IBSLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/smartup/ibslogo/androidicons/192x192.png',
          width: 120,
          height: 120,
        ),
        const SizedBox(height: Sizes.md),
        Text(
          'IBS Transport',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}