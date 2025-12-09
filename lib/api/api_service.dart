import 'dart:math';
import 'package:dio/dio.dart';
import '../models/cat_image.dart';
import '../models/breed.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.thecatapi.com/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'x-api-key':
            'live_W23IRna4nanjKLO8tW1DiZLPvEuAuiqsOcthaeOHGlShiAWsKYdu2SPRQCTfmH5C',
      },
      validateStatus: (status) => true,
    ),
  );

  static final List<CatImage> fallbackCats = [
    CatImage(
      id: 'local1',
      url: 'assets/images/cat1.jpg',
      breed: Breed(
        id: 'fb_brit',
        name: 'Британская короткошёрстная',
        origin: 'Великобритания',
        temperament: 'Спокойная, дружелюбная',
        description: 'Популярная домашняя порода с мягким нравом.',
        energyLevel: 3,
        intelligence: 4,
      ),
    ),
    CatImage(
      id: 'local2',
      url: 'assets/images/cat2.jpg',
      breed: Breed(
        id: 'fb_maine',
        name: 'Мейн-кун',
        origin: 'США',
        temperament: 'Ласковый, спокойный гигант',
        description: 'Крупная порода с удивительно дружелюбным характером.',
        energyLevel: 5,
        intelligence: 4,
      ),
    ),
    CatImage(id: 'local3', url: 'assets/images/cat3.jpg', breed: null),
  ];

  static List<Breed> get fallbackBreeds {
    final map = <String, Breed>{};

    for (final cat in fallbackCats) {
      if (cat.breed != null) {
        map[cat.breed!.id] = cat.breed!;
      }
    }

    return map.values.toList();
  }

  static Future<CatImage> getRandomCat() async {
    try {
      final res = await _dio.get(
        '/images/search',
        queryParameters: {'include_breeds': 1, 'limit': 1},
      );

      if (res.statusCode == 200 && res.data is List && res.data.isNotEmpty) {
        return CatImage.fromJson(res.data[0]);
      }

      throw Exception('Неверный ответ API');
    } catch (_) {
      final random = Random();
      return fallbackCats[random.nextInt(fallbackCats.length)];
    }
  }

  static Future<List<Breed>> getBreeds() async {
    try {
      final res = await _dio.get('/breeds');

      if (res.statusCode == 200 && res.data is List) {
        return res.data.map<Breed>((b) => Breed.fromJson(b)).toList();
      }

      throw Exception('Неверный формат ответа');
    } catch (_) {
      return fallbackBreeds;
    }
  }
}
