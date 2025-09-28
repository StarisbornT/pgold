import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/crytpo_model.dart';
import '../provider.dart';
final cryptoProvider =
StateNotifierProvider<CryptoNotifier, AsyncValue<CryptoResponse>>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return CryptoNotifier(dio, storage);
});



class CryptoNotifier extends StateNotifier<AsyncValue<CryptoResponse>> {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  CryptoNotifier(this._dio, this._storage) : super(const AsyncValue.loading());

  Future<void> getCryptos() async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.get(
        '/cryptos',
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );

      final serviceResponse = CryptoResponse.fromMap(response.data);
      state = AsyncValue.data(serviceResponse);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
