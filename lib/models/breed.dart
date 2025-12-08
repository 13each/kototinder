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
    return Breed(
      id: json['id'],
      name: json['name'],
      origin: json['origin'] ?? 'Unknown',
      temperament: json['temperament'] ?? '',
      description: json['description'] ?? '',
      energyLevel: json['energy_level'] ?? 0,
      intelligence: json['intelligence'] ?? 0,
    );
  }
}