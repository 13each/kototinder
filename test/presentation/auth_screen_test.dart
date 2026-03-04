import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kototinder/core/errors/app_exception.dart';
import 'package:kototinder/domain/repositories/auth_repository.dart';
import 'package:kototinder/domain/services/auth_validator.dart';
import 'package:kototinder/domain/usecases/sign_in_usecase.dart';
import 'package:kototinder/domain/usecases/sign_up_usecase.dart';
import 'package:kototinder/presentation/auth/auth_controller.dart';
import 'package:kototinder/presentation/auth/auth_screen.dart';

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

Widget _wrap(Widget child) {
  return MaterialApp(home: child);
}

void main() {
  testWidgets('shows validation error for invalid sign up input', (
    tester,
  ) async {
    final repository = _FakeAuthRepository();
    final controller = AuthController(
      signInUseCase: SignInUseCase(repository),
      signUpUseCase: SignUpUseCase(repository),
      validator: const AuthValidator(),
    );

    await tester.pumpWidget(
      _wrap(AuthScreen(controller: controller, onAuthenticated: () {})),
    );

    await tester.tap(find.byKey(const Key('toggleModeButton')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('emailField')), 'bad');
    await tester.enterText(find.byKey(const Key('passwordField')), '123');
    await tester.enterText(find.byKey(const Key('confirmField')), '321');

    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email.'), findsOneWidget);
    expect(
      find.text('Password must contain at least 6 characters.'),
      findsOneWidget,
    );
    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('successful sign in calls onAuthenticated callback', (
    tester,
  ) async {
    final repository = _FakeAuthRepository()
      ..registeredEmail = 'cat@example.com'
      ..registeredPassword = '123456';
    final controller = AuthController(
      signInUseCase: SignInUseCase(repository),
      signUpUseCase: SignUpUseCase(repository),
      validator: const AuthValidator(),
    );
    var authenticated = false;

    await tester.pumpWidget(
      _wrap(
        AuthScreen(
          controller: controller,
          onAuthenticated: () {
            authenticated = true;
          },
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'cat@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), '123456');
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();

    expect(authenticated, isTrue);
    expect(repository.signedIn, isTrue);
  });
}
