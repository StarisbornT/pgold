import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgold/screens/onboarding/auth/signup.dart';
import 'package:pgold/utils/appcolors.dart';

import '../../../components/label_text.dart';
import '../../../components/rounded_button.dart';
import 'package:pgold/lib/provider.dart';

import '../../../lib/auth_provider.dart';
import '../../dashboard/dashboard.dart';

// Your provided class structure
class Login extends ConsumerStatefulWidget {
  const Login({super.key});
  static String id = 'login';

  @override
  ConsumerState<Login> createState() => _LoginScreenState();
}

final emailProvider = StateProvider<String?>((ref) => null);
final passwordProvider = StateProvider<String?>((ref) => null);


class _LoginScreenState extends ConsumerState<Login> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  // Helper widget for the social login buttons
  Widget _buildSocialButton(String iconText) {
    // Note: Since we can't use real logos easily, we'll use placeholder text for the icons (X, Apple, G)
    return OutlinedButton(
      onPressed: () {
        // Handle social login
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Image.asset(iconText),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> submitForm() async {
    final dio = ref.read(dioProvider);

    // Validate all required fields
    if (
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showErrorDialog("Please fill all required fields");
      return;
    }

    try {
      ref.read(isLoadingProvider.notifier).state = true;

      Map<String, String> payload = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      final options = Options(headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

      final response = await dio.post(
          '/auth/login',
          data: jsonEncode(payload),
          options: options
      );
      ref.read(isLoadingProvider.notifier).state = false;

      if (response.statusCode == 200) {
        final responseData = response.data;
        await ref.read(authStateProvider.notifier).setToken(responseData['token']);
        Navigator.pushNamed(context, DashboardScreen.id);
      } else {
        _showErrorDialog("Registration failed. Please try again.");
      }
    } catch(error) {
      ref.read(isLoadingProvider.notifier).state = false;
      _handleError(error);
    }
  }

  void _handleError(dynamic error) {
    String errorMessage = "An error occurred. Please try again.";

    if (error is DioError) {
      if (error.response != null && error.response!.data != null) {
        Map<String, dynamic> responseData = error.response!.data;
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData.containsKey('errors')) {
          Map<String, dynamic> errors = responseData['errors'];
          List<String> errorMessages = [];
          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessages.addAll(value.map((error) => "$key: $error"));
            }
          });
          errorMessage = errorMessages.join("\n");
        }
      }
    }

    _showErrorDialog(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    final loading = ref.watch(isLoadingProvider);

    bool isFormValid = email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),

              // Title: Welcome back
              const Text(
                'Welcome back 👋',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Sign in to start using your Pgold Account!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              LabeledTextField(
                label: "Email Address",
                hintText: "name@example.com",
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                provider: emailProvider,
              ),
              const SizedBox(height: 24),

              // Password Field
              LabeledTextField(
                label: "Password",
                hintText: "Enter Password",
                isPassword: true,
                controller: _passwordController,
                provider: passwordProvider,
                prefixIcon: Icons.key,
              ),
              const SizedBox(height: 16),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _rememberMe = newValue ?? false;
                            });
                          },

                          activeColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Remember me', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Forgot Password screen
                    },
                    child:  const Text(
                      'Forgot Password!',
                      style: TextStyle(
                        color: AppColors.PRIMARYCOLOR,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Next Button (Disabled appearance)
              RoundedButton(
                title: loading ? 'Submitting...' : 'Next',
                onPressed: isFormValid && !loading
                    ? () {
                  submitForm();
                }
                    : null,
                borderWidth: 0,
                color: isFormValid && !loading
                    ? AppColors.PRIMARYCOLOR  // enabled = primary
                    : Colors.grey.shade200,   // disabled = grey
              ),

              const SizedBox(height: 30),

              // OR Login With Divider
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(color: Colors.grey.shade300),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'or login with',
                      style: TextStyle(color: Color(0xFF718096), fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade300),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(child: _buildSocialButton('images/x.png')), // Placeholder for Twitter/X
                  const SizedBox(width: 16),
                  Expanded(child: _buildSocialButton('images/apple.png')), // Placeholder for Apple
                  const SizedBox(width: 16),
                  Expanded(child: _buildSocialButton('images/google.png')), // Placeholder for Google
                ],
              ),
              const SizedBox(height: 10),

              // Don't have an account? Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 16, color: Color(0xFF718096)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child:  const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.PRIMARYCOLOR,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.PRIMARYCOLOR,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}