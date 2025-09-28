
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pgold/lib/provider.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.watch(storageProvider));
});

class AuthState {
  final String? token;
  final bool isLoading;

  AuthState({this.token, this.isLoading = true});
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage;

  AuthStateNotifier(this._storage) : super(AuthState()) {
    init();
  }

  Future<void> init() async {
    final token = await _storage.read(
      key: 'auth_token',
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
    state = AuthState(token: token, isLoading: false);
  }

  Future<void> setToken(String token) async {
    await _storage.write(
      key: 'auth_token',
      value: token,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
    state = AuthState(token: token, isLoading: false);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
    state = AuthState(token: null, isLoading: false);
  }
}