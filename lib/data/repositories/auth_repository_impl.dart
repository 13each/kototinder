import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;
  static final RegExp _sha256Regex = RegExp(r'^[a-f0-9]{64}$');

  @override
  Future<void> signUp({required String email, required String password}) async {
    final passwordHash = _hashPassword(password);
    await _localDataSource.saveCredentials(
      email: email,
      password: passwordHash,
    );
    await _localDataSource.setSignedIn(true);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    final registeredEmail = await _localDataSource.getRegisteredEmail();
    final registeredPassword = await _localDataSource.getRegisteredPassword();

    if (registeredEmail == null || registeredPassword == null) {
      throw const AppException('No local account found. Create one first.');
    }

    if (registeredEmail != email) {
      throw const AppException('Wrong email or password.');
    }

    final inputHash = _hashPassword(password);
    final isStoredHash = _sha256Regex.hasMatch(registeredPassword);
    final isValidPassword = isStoredHash
        ? registeredPassword == inputHash
        : registeredPassword == password;

    if (!isValidPassword) {
      throw const AppException('Wrong email or password.');
    }

    if (!isStoredHash) {
      await _localDataSource.saveCredentials(
        email: registeredEmail,
        password: inputHash,
      );
    }

    await _localDataSource.setSignedIn(true);
  }

  @override
  Future<void> signOut() => _localDataSource.setSignedIn(false);

  @override
  Future<bool> isSignedIn() => _localDataSource.isSignedIn();

  @override
  Future<bool> isOnboardingCompleted() =>
      _localDataSource.isOnboardingCompleted();

  @override
  Future<void> completeOnboarding() {
    return _localDataSource.setOnboardingCompleted(true);
  }

  String _hashPassword(String value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }
}
