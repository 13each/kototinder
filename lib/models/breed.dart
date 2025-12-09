class Breed {
  final String id;
  final String name;
  final String origin;
  final String temperament;
  final String description;
  final int energyLevel;
  final int intelligence;

  Breed({
    required this.id,
    required this.name,
    required this.origin,
    required this.temperament,
    required this.description,
    required this.energyLevel,
    required this.intelligence,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      return 0;
    }

    return Breed(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      origin: json['origin'] ?? 'Unknown',
      temperament: json['temperament'] ?? '',
      description: json['description'] ?? '',
      energyLevel: safeInt(json['energy_level']),
      intelligence: safeInt(json['intelligence']),
    );
  }
}
