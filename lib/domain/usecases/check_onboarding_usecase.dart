import '../repositories/auth_repository.dart';

class CheckOnboardingUseCase {
  const CheckOnboardingUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() => _repository.isOnboardingCompleted();
}
