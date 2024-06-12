import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../models/product.dart';

class NetworkService {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      receiveDataWhenStatusError: true,
      responseType: ResponseType.json,
    ),
  );
  Future<Either<Left, dynamic>> get(String url) async {
    try {
      final response = await dio.get(url);
      return right(response.data);
    } on DioException catch (e, stackTrace) {
      log('$e', stackTrace: stackTrace);
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return left(const Left('Connection timeout'));
        case DioExceptionType.receiveTimeout:
          return left(const Left('Receive timeout'));
        case DioExceptionType.badResponse:
          return left(const Left('Bad response'));
        default:
          return left(const Left('Unknown error'));
      }
    } catch (e) {
      log('$e');
      rethrow;
    }
  }
}
