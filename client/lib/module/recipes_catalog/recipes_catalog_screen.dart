import 'package:flutter/material.dart';

class RecipesCatalogScreen extends StatelessWidget {
  const RecipesCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
      ),
      body: Center(
        child: Text(
          'Каталог рецептов',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
