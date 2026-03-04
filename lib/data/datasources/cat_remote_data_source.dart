import 'package:dio/dio.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/breed.dart';
import '../../domain/entities/cat_image.dart';
import '../models/breed_model.dart';
import '../models/cat_image_model.dart';

class CatRemoteDataSource {
  CatRemoteDataSource({required Dio dio}) : _dio = dio;

  factory CatRemoteDataSource.create() {
    final apiKey = const String.fromEnvironment(
      'CAT_API_KEY',
      defaultValue: '',
    );
    final headers = <String, dynamic>{};
    if (apiKey.isNotEmpty) {
      headers['x-api-key'] = apiKey;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.thecatapi.com/v1',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: headers,
        validateStatus: (status) => true,
      ),
    );
    return CatRemoteDataSource(dio: dio);
  }

  final Dio _dio;

  Future<CatImage> fetchRandomCatWithBreed() async {
    try {
      final response = await _dio.get(
        '/images/search',
        queryParameters: {'include_breeds': 1, 'has_breeds': 1, 'limit': 1},
      );

      if (response.statusCode == 200 &&
          response.data is List &&
          (response.data as List).isNotEmpty) {
        final item = (response.data as List).first;
        if (item is Map<String, dynamic>) {
          return CatImageModel.fromJson(item);
        }
      }

      throw const AppException('Invalid response while loading random cat.');
    } on DioException catch (e) {
      throw AppException(_mapDioError(e));
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to load random cat: $e');
    }
  }

  Future<CatImage> fetchRandomCatByBreedId(String breedId) async {
    try {
      final response = await _dio.get(
        '/images/search',
        queryParameters: {'breed_ids': breedId, 'limit': 1},
      );

      if (response.statusCode == 200 &&
          response.data is List &&
          (response.data as List).isNotEmpty) {
        final item = (response.data as List).first;
        if (item is Map<String, dynamic>) {
          return CatImageModel.fromJson(item);
        }
      }

      throw AppException('No image found for breed id: $breedId');
    } on DioException catch (e) {
      throw AppException(_mapDioError(e));
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to load cat image by breed: $e');
    }
  }

  Future<List<Breed>> fetchBreeds() async {
    try {
      final response = await _dio.get('/breeds');

      if (response.statusCode == 200 && response.data is List) {
        final data = response.data as List;
        return data
            .whereType<Map<String, dynamic>>()
            .map(BreedModel.fromJson)
            .toList();
      }

      throw const AppException('Invalid response while loading breeds.');
    } on DioException catch (e) {
      throw AppException(_mapDioError(e));
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to load breeds: $e');
    }
  }

  String _mapDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return 'Server error ($statusCode). Please try again later.';
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Request timed out. Please check your internet connection.',
      DioExceptionType.connectionError =>
        'No internet connection. Please try again.',
      DioExceptionType.cancel => 'Request was cancelled.',
      _ => 'Network error while connecting to TheCatAPI.',
    };
  }
}
