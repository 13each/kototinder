import 'package:flutter/material.dart';

import '../../domain/entities/cat_image.dart';
import '../widgets/cat_image_view.dart';

class CatDetailScreen extends StatelessWidget {
  const CatDetailScreen({super.key, required this.cat});

  final CatImage cat;

  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;

    return Scaffold(
      appBar: AppBar(title: Text(breed?.name ?? 'Cat details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: SizedBox(
                height: 320,
                width: double.infinity,
                child: CatImageView(url: cat.url),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              breed?.name ?? 'Unknown breed',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            if (breed == null)
              const Text('No breed information is available for this cat.')
            else ...[
              Text(
                breed.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 14),
              _InfoLine(title: 'Origin', value: breed.origin),
              _InfoLine(title: 'Temperament', value: breed.temperament),
              _InfoLine(title: 'Energy level', value: '${breed.energyLevel}/5'),
              _InfoLine(
                title: 'Intelligence',
                value: '${breed.intelligence}/5',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF566A7E),
                ),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }
}
