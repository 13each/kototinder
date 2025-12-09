import 'package:flutter/material.dart';
import '../models/cat_image.dart';

class CatDetailScreen extends StatelessWidget {
  final CatImage cat;
  const CatDetailScreen({super.key, required this.cat});
  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;
    return Scaffold(
      appBar: AppBar(title: Text(breed?.name ?? 'Котик')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  cat.url,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                breed?.name ?? 'Неизвестная порода',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (breed == null)
                const Text(
                  'У этого котика нет описания ',
                  style: TextStyle(fontSize: 16),
                ),
              if (breed != null) ...[
                Text(breed.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Text(
                  'Темперамент: ${breed.temperament}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Страна происхождения: ${breed.origin}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  'Характеристики:',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Энергичность: ${breed.energyLevel}/5'),
                Text('Интеллект: ${breed.intelligence}/5'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
