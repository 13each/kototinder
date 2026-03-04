import '../../domain/entities/breed.dart';

class BreedModel {
  static Breed fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic value) {
      if (value is int) {
        return value;
      }
      if (value is double) {
        return value.toInt();
      }
      return 0;
    }

    return Breed(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      origin: json['origin']?.toString() ?? 'Unknown',
      temperament: json['temperament']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      energyLevel: safeInt(json['energy_level']),
      intelligence: safeInt(json['intelligence']),
    );
  }
}
