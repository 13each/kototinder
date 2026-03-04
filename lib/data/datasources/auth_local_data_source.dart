import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCredentials({
    required String email,
    required String password,
  });
  Future<String?> getRegisteredEmail();
  Future<String?> getRegisteredPassword();
  Future<void> setSignedIn(bool value);
  Future<bool> isSignedIn();
  Future<void> setOnboardingCompleted(bool value);
  Future<bool> isOnboardingCompleted();
}

class SecureStorageAuthLocalDataSource implements AuthLocalDataSource {
  SecureStorageAuthLocalDataSource(this._storage);

  static const _emailKey = 'auth_email';
  static const _passwordKey = 'auth_password';
  static const _signedInKey = 'auth_signed_in';
  static const _onboardingKey = 'onboarding_completed';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  @override
  Future<String?> getRegisteredEmail() => _storage.read(key: _emailKey);

  @override
  Future<String?> getRegisteredPassword() => _storage.read(key: _passwordKey);

  @override
  Future<void> setSignedIn(bool value) {
    return _storage.write(key: _signedInKey, value: value.toString());
  }

  @override
  Future<bool> isSignedIn() async {
    final value = await _storage.read(key: _signedInKey);
    return value == 'true';
  }

  @override
  Future<void> setOnboardingCompleted(bool value) {
    return _storage.write(key: _onboardingKey, value: value.toString());
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }
}
