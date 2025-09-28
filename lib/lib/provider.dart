import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:local_auth/local_auth.dart';
import 'authInterceptor.dart';
import 'interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final storageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// final biometricAuthProvider = Provider<LocalAuthentication>((ref) {
//   return LocalAuthentication();
// });

// Device Biometric Support Check Provider
// final biometricSupportProvider = FutureProvider<bool>((ref) async {
//   final auth = ref.read(biometricAuthProvider);
//   return await auth.isDeviceSupported();
// });

// Biometric Status Provider (enabled/disabled)
final biometricsEnabledProvider = FutureProvider.autoDispose<bool>((ref) async {
  final storage = ref.read(storageProvider);
  final value = await storage.read(
    key: 'biometrics_enabled',
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  );
  return value == 'true';
});

// Biometric Service Provider (combines all functionality)
// final biometricServiceProvider = Provider<BiometricService>((ref) {
//   return BiometricService(ref);
// });

// final biometricsAvailableProvider = FutureProvider<bool>((ref) async {
//   final biometricService = ref.watch(biometricServiceProvider);
//   final isSupported = await biometricService.isDeviceSupported();
//   if (!isSupported) return false;
//   return biometricService.isEnabled();
// });
//
// class BiometricService {
//   final Ref _ref;
//
//   BiometricService(this._ref);
//
//   FlutterSecureStorage get _storage => _ref.read(storageProvider);
//   LocalAuthentication get _auth => _ref.read(biometricAuthProvider);
//
//   // Check if device supports biometrics
//   Future<bool> isDeviceSupported() async {
//     return await _auth.isDeviceSupported();
//   }
//
//   // Check if biometrics are enabled in app settings
//   Future<bool> isEnabled() async {
//     final value = await _storage.read(
//       key: 'biometrics_enabled',
//       aOptions: const AndroidOptions(encryptedSharedPreferences: true),
//     );
//     return value == 'true';
//   }
//
//   // Enable biometrics (after successful authentication)
//   Future<void> enable() async {
//     await _storage.write(
//       key: 'biometrics_enabled',
//       value: 'true',
//       aOptions: const AndroidOptions(encryptedSharedPreferences: true),
//     );
//     _ref.refresh(biometricsEnabledProvider);
//   }
//
//   // Disable biometrics
//   Future<void> disable() async {
//     await _storage.delete(
//       key: 'biometrics_enabled',
//       aOptions: const AndroidOptions(encryptedSharedPreferences: true),
//     );
//     _ref.refresh(biometricsEnabledProvider);
//   }
//
//   // Perform biometric authentication
//   Future<bool> authenticate(String reason) async {
//     try {
//       final result = await _auth.authenticate(
//         localizedReason: reason,
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//
//       // Only clear token if authentication was explicitly canceled by user
//       if (!result) {
//         return false;
//       }
//       return true;
//     } catch (e) {
//       // Don't clear token on errors, just return false
//       return false;
//     }
//   }
//
//   // Get available biometric types
//   Future<List<BiometricType>> getAvailableBiometrics() async {
//     return await _auth.getAvailableBiometrics();
//   }
// }

void initializeDioLogger(Dio dio) {
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ),
  );
}

// Define a provider for Dio
final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(storageProvider);
  final dio = Dio();
  dio.interceptors.addAll([
    BaseUrlInterceptor(),
    TokenInterceptor(storage: storage),
    AuthInterceptor(ref), // Updated to take Ref
  ]);
  initializeDioLogger(dio);
  return dio;
});
final recieptProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {};
});
final bottomNavigationBarIndexProvider = StateProvider<int>((ref) => 0);
