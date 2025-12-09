import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/breed.dart';
import 'breed_detail_screen.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  List<Breed> breeds = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadBreeds();
  }

  Future<void> loadBreeds() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await ApiService.getBreeds();
      setState(() {
        breeds = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки пород: $e');
      setState(() {
        errorMessage =
            'Ошибка загрузки списка пород.\nПроверьте подключение к интернету.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadBreeds,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: breeds.length,
      itemBuilder: (context, index) {
        final breed = breeds[index];
        return ListTile(
          title: Text(breed.name),
          subtitle: Text(breed.origin),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BreedDetailScreen(breed: breed),
              ),
            );
          },
        );
      },
    );
  }
}
