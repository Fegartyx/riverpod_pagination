import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pagination_riverpod/models/product.dart';
import 'package:pagination_riverpod/services/network_service.dart';

import 'package:fpdart/fpdart.dart';

final networkProvider = Provider<NetworkService>((ref) {
  print('networkProvider');
  return NetworkService();
});

// final getService = FutureProvider.family<dynamic, String>((ref, url) async {
//   final service = ref.read(networkProvider);
//   final data = await service.get(url);
//   print('service $data');
//   return data;
// });

class PaginatorController
    extends AutoDisposeAsyncNotifier<Option<Either<Left, Product?>>> {
  static int _limit = 10;
  static String _url = "https://dummyjson.com/products";
  static int totalProduct = 0;
  bool hasMore = true;
  @override
  FutureOr<Option<Either<Left, Product?>>> build() async {
    final data = await getProducts(_limit);
    return optionOf(data);
  }

  Future<Either<Left, Product?>> getProducts(int limit) async {
    final String url = "$_url?limit=$_limit";
    final response = ref.watch(networkProvider);
    final data = await response.get(url);
    return data.fold(
      (l) => left(l),
      (r) async {
        final products = Product.fromJson(r);
        totalProduct = products.total;
        return right(products);
      },
    );
  }

  Future<void> loadNextPage() async {
    try {
      if (totalProduct <= _limit) {
        hasMore = false;
        state = state.copyWithPrevious(state);
        return;
      }
      _limit = _limit + 10;
      final data = await getProducts(_limit);
      state = AsyncData(optionOf(data));
    } catch (e, stackTrace) {
      log('$e', stackTrace: stackTrace);
      rethrow;
    }
  }
}

final paginatorControllerProvider = AsyncNotifierProvider.autoDispose<
    PaginatorController, Option<Either<Left, Product?>>>(
  () => PaginatorController(),
);
