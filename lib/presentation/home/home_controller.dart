import 'package:flutter/foundation.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/cat_image.dart';
import '../../domain/usecases/get_random_cat_usecase.dart';

class HomeController extends ChangeNotifier {
  HomeController({required GetRandomCatUseCase getRandomCatUseCase})
    : _getRandomCatUseCase = getRandomCatUseCase;

  final GetRandomCatUseCase _getRandomCatUseCase;

  CatImage? _currentCat;
  bool _isLoading = false;
  String? _errorMessage;
  int _likes = 0;

  CatImage? get currentCat => _currentCat;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get likes => _likes;

  Future<void> loadCat() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentCat = await _getRandomCatUseCase();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Unexpected error while loading cat: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> like() async {
    _likes += 1;
    notifyListeners();
    await loadCat();
  }

  Future<void> dislike() async {
    await loadCat();
  }
}
