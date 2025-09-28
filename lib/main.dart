import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pgold/screens/dashboard/dashboard.dart';
import 'package:pgold/screens/onboarding/auth/login.dart';
import 'package:pgold/screens/onboarding/auth/signup.dart';
import 'package:pgold/screens/onboarding/onboard.dart';
import 'package:pgold/screens/onboarding/splash_screen.dart';
import 'package:pgold/services/loading_service.dart';

import 'lib/auth_provider.dart';
import 'lib/interceptor.dart';
import 'lib/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final container = ProviderContainer();
  Dio dio = Dio();
  initializeDioLogger(dio);
  final storage = const FlutterSecureStorage();

  await container.read(authStateProvider.notifier).init();


  dio.interceptors.addAll([
    BaseUrlInterceptor(),
    TokenInterceptor(storage: storage),
  ]);
  runApp(const ProviderScope(child: PGold()));
}

class PGold extends StatelessWidget {
  const PGold({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: LoaderService.navigatorKey,
      theme: ThemeData(
        textTheme: GoogleFonts.soraTextTheme(),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        Onboard.id: (context) => const Onboard(),
        SignupScreen.id: (context) => const SignupScreen(),
        Login.id: (context) => const Login(),
        DashboardScreen.id: (context) => const DashboardScreen(),
      },
    );
  }
}