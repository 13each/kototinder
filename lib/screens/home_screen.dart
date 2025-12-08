import '../api/api_service.dart';
import '../models/cat_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CatImage? currentCat;
  int likes = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCat();
  }

  Future<void> loadCat() async {
    setState(() => isLoading = true);
    try {
      final cat = await ApiService.getRandomCat();
      setState(() {
        currentCat = cat;
        isLoading = false;
      });
    }
    catch (e) {
      print('Ошибка $e');
    }
  }

  void like() {
    setState(() {
      likes++;
    });
    loadCat();
  }

  void dislike() {
    setState(() {
      loadCat();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || currentCat == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final cat = currentCat!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Лайки: $likes',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                dislike();
              } else {
                like();
              }
            },
            child: GestureDetector(
              onTap: () {

              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  cat.url,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          cat.breed?.name ?? 'Без породы',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.close, size: 40, color: Colors.red),
              onPressed: dislike,
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.close, size: 40, color: Colors.green),
              onPressed: like,
            ),
          ],
        )
      ],
    );
  }
}