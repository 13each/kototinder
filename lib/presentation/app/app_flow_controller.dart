import 'package:flutter/foundation.dart';

import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/check_onboarding_usecase.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

enum AppFlowState { loading, onboarding, auth, main }

class AppFlowController extends ChangeNotifier {
  AppFlowController({
    required CheckOnboardingUseCase checkOnboardingUseCase,
    required CompleteOnboardingUseCase completeOnboardingUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _checkOnboardingUseCase = checkOnboardingUseCase,
       _completeOnboardingUseCase = completeOnboardingUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _signOutUseCase = signOutUseCase;

  final CheckOnboardingUseCase _checkOnboardingUseCase;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final SignOutUseCase _signOutUseCase;

  AppFlowState _state = AppFlowState.loading;

  AppFlowState get state => _state;

  Future<void> bootstrap() async {
    _state = AppFlowState.loading;
    notifyListeners();

    final onboardingDone = await _checkOnboardingUseCase();
    if (!onboardingDone) {
      _state = AppFlowState.onboarding;
      notifyListeners();
      return;
    }

    final isSignedIn = await _checkAuthStatusUseCase();
    _state = isSignedIn ? AppFlowState.main : AppFlowState.auth;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _completeOnboardingUseCase();
    _state = AppFlowState.auth;
    notifyListeners();
  }

  void onAuthenticated() {
    _state = AppFlowState.main;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    _state = AppFlowState.auth;
    notifyListeners();
  }
}
