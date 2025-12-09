import 'package:flutter/material.dart';
import '../models/breed.dart';

class BreedDetailScreen extends StatelessWidget {
  final Breed breed;

  const BreedDetailScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                breed.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(breed.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text(
                'Страна происхождения: ${breed.origin}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Темперамент: ${breed.temperament}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Характеристики:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Энергичность: ${breed.energyLevel}/5'),
              Text('Интеллект: ${breed.intelligence}/5'),
            ],
          ),
        ),
      ),
    );
  }
}
