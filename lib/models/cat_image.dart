import 'breed.dart';

class CatImage {
  final String id;
  final String url;
  final Breed? breed;

  CatImage({required this.id, required this.url, required this.breed});

  factory CatImage.fromJson(Map<String, dynamic> json) {
    final breeds = (json['breeds'] as List?) ?? [];

    return CatImage(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      breed: breeds.isNotEmpty ? Breed.fromJson(breeds.first) : null,
    );
  }
}
