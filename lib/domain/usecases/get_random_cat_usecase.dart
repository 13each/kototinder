import '../entities/cat_image.dart';
import '../repositories/cat_repository.dart';

class GetRandomCatUseCase {
  const GetRandomCatUseCase(this._repository);

  final CatRepository _repository;

  Future<CatImage> call() => _repository.getRandomCat();
}
