import 'package:flutter/material.dart';

class FridgeScannerScreen extends StatelessWidget {
  const FridgeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканер'),
      ),
      body: Center(
        child: Text(
          'Сканер холодильника',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
