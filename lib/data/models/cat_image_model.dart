import '../../domain/entities/cat_image.dart';
import 'breed_model.dart';

class CatImageModel {
  static CatImage fromJson(Map<String, dynamic> json) {
    final breeds = (json['breeds'] as List?) ?? const [];
    return CatImage(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      breed: breeds.isNotEmpty && breeds.first is Map<String, dynamic>
          ? BreedModel.fromJson(breeds.first as Map<String, dynamic>)
          : null,
    );
  }
}
