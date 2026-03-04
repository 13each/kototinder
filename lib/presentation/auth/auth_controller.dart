import 'package:flutter/foundation.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/services/auth_validator.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

enum AuthMode { signIn, signUp }

class AuthController extends ChangeNotifier {
  AuthController({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required AuthValidator validator,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _validator = validator;

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final AuthValidator _validator;

  AuthMode _mode = AuthMode.signIn;
  bool _isLoading = false;
  String? _errorMessage;

  AuthMode get mode => _mode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void switchMode(AuthMode mode) {
    _mode = mode;
    _errorMessage = null;
    notifyListeners();
  }

  String? validateEmail(String? value) => _validator.validateEmail(value ?? '');

  String? validatePassword(String? value) {
    return _validator.validatePassword(value ?? '');
  }

  String? validateConfirmPassword(String password, String? confirmPassword) {
    if (_mode != AuthMode.signUp) {
      return null;
    }
    return _validator.validateConfirmPassword(
      password: password,
      confirmPassword: confirmPassword ?? '',
    );
  }

  Future<bool> submit({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_mode == AuthMode.signIn) {
        await _signInUseCase(email: email.trim(), password: password);
      } else {
        await _signUpUseCase(email: email.trim(), password: password);
      }
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Auth submit unexpected error: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
      _errorMessage =
          'Something went wrong during authentication. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
