import 'package:flutter/material.dart';
import '../components/loader.dart';

class LoaderService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static bool _isShowing = false;

  static void showLoader(BuildContext context) {
    if (_isShowing) return; // prevent multiple dialogs
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LogoLoader(
        logoPath: 'images/icon.png',
      ),
    );
  }

  static void hideLoader(BuildContext context) {
    if (_isShowing) {
      Navigator.of(context, rootNavigator: true).pop();
      _isShowing = false;
    }
  }
}
