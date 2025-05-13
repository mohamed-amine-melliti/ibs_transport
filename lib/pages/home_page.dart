import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Vide'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // 👇 Navigate back to the first page (e.g. "/")
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          },
          icon: const Icon(Icons.home),
          label: const Text('Aller à la première page'),
        ),
      ),
    );
  }
}
