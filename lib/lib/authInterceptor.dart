import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_provider.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authState = ref.read(authStateProvider);
    if (authState.token != null) {
      options.headers['Authorization'] = 'Bearer ${authState.token}';
    }
    super.onRequest(options, handler);
  }
}
