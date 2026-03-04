import 'package:flutter/foundation.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/breed.dart';
import '../../domain/usecases/get_breeds_usecase.dart';

class BreedsController extends ChangeNotifier {
  BreedsController({required GetBreedsUseCase getBreedsUseCase})
    : _getBreedsUseCase = getBreedsUseCase;

  final GetBreedsUseCase _getBreedsUseCase;

  List<Breed> _breeds = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Breed> get breeds => _breeds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBreeds() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _breeds = await _getBreedsUseCase();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Unexpected error while loading breeds: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
