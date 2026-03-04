import 'dart:math';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/breed.dart';
import '../../domain/entities/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_data_source.dart';

class CatRepositoryImpl implements CatRepository {
  CatRepositoryImpl(this._remoteDataSource);

  final CatRemoteDataSource _remoteDataSource;
  final Random _random = Random();
  List<Breed>? _breedsCache;

  @override
  Future<CatImage> getRandomCat() async {
    try {
      final cat = await _remoteDataSource.fetchRandomCatWithBreed();
      if (cat.url.isNotEmpty && cat.breed != null) {
        return cat;
      }
    } catch (_) {
    }

    final breeds = await getBreeds();
    if (breeds.isEmpty) {
      throw const AppException('Breeds list is empty.');
    }

    for (var i = 0; i < 10; i++) {
      final breed = breeds[_random.nextInt(breeds.length)];
      final cat = await _remoteDataSource.fetchRandomCatByBreedId(breed.id);
      if (cat.url.isNotEmpty) {
        return CatImage(id: cat.id, url: cat.url, breed: breed);
      }
    }

    throw const AppException('Failed to load cat image with breed data.');
  }

  @override
  Future<List<Breed>> getBreeds() async {
    final cache = _breedsCache;
    if (cache != null && cache.isNotEmpty) {
      return cache;
    }

    final breeds = await _remoteDataSource.fetchBreeds();
    _breedsCache = breeds;
    return breeds;
  }
}
