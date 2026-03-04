import 'package:flutter_test/flutter_test.dart';
import 'package:kototinder/core/errors/app_exception.dart';
import 'package:kototinder/domain/repositories/auth_repository.dart';
import 'package:kototinder/domain/usecases/sign_in_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  String? registeredEmail;
  String? registeredPassword;
  bool signedIn = false;
  bool onboardingDone = false;

  @override
  Future<void> completeOnboarding() async {
    onboardingDone = true;
  }

  @override
  Future<bool> isOnboardingCompleted() async => onboardingDone;

  @override
  Future<bool> isSignedIn() async => signedIn;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (registeredEmail == null || registeredPassword == null) {
      throw const AppException('No local account found. Create one first.');
    }
    if (registeredEmail != email || registeredPassword != password) {
      throw const AppException('Wrong email or password.');
    }
    signedIn = true;
  }

  @override
  Future<void> signOut() async {
    signedIn = false;
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    registeredEmail = email;
    registeredPassword = password;
    signedIn = true;
  }
}

void main() {
  test('sign in succeeds with correct credentials and sets session', () async {
    final repository = _FakeAuthRepository()
      ..registeredEmail = 'cat@example.com'
      ..registeredPassword = '123456';
    final useCase = SignInUseCase(repository);

    await useCase(email: 'cat@example.com', password: '123456');

    expect(repository.signedIn, isTrue);
  });

  test('sign in throws error with invalid credentials', () async {
    final repository = _FakeAuthRepository()
      ..registeredEmail = 'cat@example.com'
      ..registeredPassword = '123456';
    final useCase = SignInUseCase(repository);

    expect(
      () => useCase(email: 'cat@example.com', password: 'bad-pass'),
      throwsA(isA<AppException>()),
    );
  });
}
