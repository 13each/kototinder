import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_image.dart';
import '../models/breed.dart';

class ApiService {
  static const _baseUrl = 'https://api.thecatapi.com/v1';

  static Future<CatImage> getRandomCat() async {
    final url = Uri.parse('$_baseUrl/images/search');

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return CatImage.fromJson(data.first);
    } else {
      throw Exception('Ошибка загрузки котика: ${res.statusCode}');
    }
  }

  static Future<List<Breed>> getBreeds() async {
    final url = Uri.parse('$_baseUrl/breeds');

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Breed.fromJson(e)).toList();
    } else {
      throw Exception('Ошибка загрузки пород: ${res.statusCode}');
    }
  }
}
