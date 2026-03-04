import '../entities/breed.dart';
import '../repositories/cat_repository.dart';

class GetBreedsUseCase {
  const GetBreedsUseCase(this._repository);

  final CatRepository _repository;

  Future<List<Breed>> call() => _repository.getBreeds();
}
