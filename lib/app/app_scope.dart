import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/datasources/auth_local_data_source.dart';
import '../data/datasources/cat_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/cat_repository_impl.dart';
import '../domain/services/auth_validator.dart';
import '../domain/usecases/check_auth_status_usecase.dart';
import '../domain/usecases/check_onboarding_usecase.dart';
import '../domain/usecases/complete_onboarding_usecase.dart';
import '../domain/usecases/get_breeds_usecase.dart';
import '../domain/usecases/get_random_cat_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../presentation/app/app_flow_controller.dart';
import '../presentation/auth/auth_controller.dart';
import '../presentation/breeds/breeds_controller.dart';
import '../presentation/home/home_controller.dart';

class AppScope {
  AppScope._({
    required this.appFlowController,
    required this.authController,
    required this.homeController,
    required this.breedsController,
  });

  final AppFlowController appFlowController;
  final AuthController authController;
  final HomeController homeController;
  final BreedsController breedsController;

  factory AppScope.create() {
    const storage = FlutterSecureStorage();
    final authLocalDataSource = SecureStorageAuthLocalDataSource(storage);
    final authRepository = AuthRepositoryImpl(authLocalDataSource);
    final catRemoteDataSource = CatRemoteDataSource.create();
    final catRepository = CatRepositoryImpl(catRemoteDataSource);

    final signInUseCase = SignInUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);
    final signOutUseCase = SignOutUseCase(authRepository);
    final checkAuthStatusUseCase = CheckAuthStatusUseCase(authRepository);
    final checkOnboardingUseCase = CheckOnboardingUseCase(authRepository);
    final completeOnboardingUseCase = CompleteOnboardingUseCase(authRepository);

    final getRandomCatUseCase = GetRandomCatUseCase(catRepository);
    final getBreedsUseCase = GetBreedsUseCase(catRepository);

    return AppScope._(
      appFlowController: AppFlowController(
        checkOnboardingUseCase: checkOnboardingUseCase,
        completeOnboardingUseCase: completeOnboardingUseCase,
        checkAuthStatusUseCase: checkAuthStatusUseCase,
        signOutUseCase: signOutUseCase,
      ),
      authController: AuthController(
        signInUseCase: signInUseCase,
        signUpUseCase: signUpUseCase,
        validator: const AuthValidator(),
      ),
      homeController: HomeController(getRandomCatUseCase: getRandomCatUseCase),
      breedsController: BreedsController(getBreedsUseCase: getBreedsUseCase),
    );
  }
}
