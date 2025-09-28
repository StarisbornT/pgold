import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/giftcard_model.dart';
import '../provider.dart';
final giftcardProvider =
StateNotifierProvider<GiftCardNotifier, AsyncValue<GiftCardResponse>>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return GiftCardNotifier(dio, storage);
});



class GiftCardNotifier extends StateNotifier<AsyncValue<GiftCardResponse>> {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  GiftCardNotifier(this._dio, this._storage) : super(const AsyncValue.loading());

  Future<void> getGiftCard() async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.get(
        '/giftcards',
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );

      final serviceResponse = GiftCardResponse.fromMap(response.data);
      state = AsyncValue.data(serviceResponse);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
