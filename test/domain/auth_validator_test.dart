import 'package:flutter_test/flutter_test.dart';
import 'package:kototinder/domain/services/auth_validator.dart';

void main() {
  const validator = AuthValidator();

  test('returns error for invalid email', () {
    expect(validator.validateEmail('wrong-email'), 'Enter a valid email.');
  });

  test('returns error for short password', () {
    expect(
      validator.validatePassword('123'),
      'Password must contain at least 6 characters.',
    );
  });

  test('returns error for different passwords', () {
    expect(
      validator.validateConfirmPassword(
        password: '123456',
        confirmPassword: '654321',
      ),
      'Passwords do not match.',
    );
  });
}
