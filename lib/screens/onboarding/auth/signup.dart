import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:pgold/components/rounded_button.dart';
import 'package:pgold/screens/onboarding/auth/login.dart';
import 'package:pgold/utils/appcolors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../components/label_text.dart';
import 'package:pgold/lib/provider.dart';
import '../../../services/loading_service.dart';
import '../../../utils/utils.dart';

/// Providers
final usernameProvider = StateProvider<String?>((ref) => null);
final emailProvider = StateProvider<String?>((ref) => null);
final otpProvider = StateProvider<String?>((ref) => null);
final fullNameProvider = StateProvider<String?>((ref) => null);
final phoneNumberProvider = StateProvider<String?>((ref) => null);
final referralCodeProvider = StateProvider<String?>((ref) => null);
final hearAboutUsProvider = StateProvider<String?>((ref) => null);
final passwordProvider = StateProvider<String?>((ref) => null);
final confirmPasswordProvider = StateProvider<String?>((ref) => null);
final currentStepProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  static String id = 'create_account';

  @override
  ConsumerState<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  final TextEditingController _hearAboutUsController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();



  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _referralController.dispose();
    _hearAboutUsController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    final dio = ref.read(dioProvider);
    final normalizedPhone = Utils.normalizePhoneNumber(_phoneNumberController.text);

    // Validate all required fields
    if (_fullNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showErrorDialog("Please fill all required fields");
      return;
    }

    // Validate password match
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match");
      return;
    }

    try {
      ref.read(isLoadingProvider.notifier).state = true;
      LoaderService.showLoader(context);

      Map<String, String> payload = {
        "full_name": _fullNameController.text,
        "user_name": _usernameController.text,
        "phone_number": normalizedPhone,
        "email": _emailController.text,
        "password": _passwordController.text,
        "password_confirmation": _confirmPasswordController.text,
        "referral_code": _referralController.text,
        "heard_about_us": _hearAboutUsController.text,
      };

      final options = Options(headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

      final response = await dio.post(
          '/auth/register',
          data: jsonEncode(payload),
          options: options
      );

      LoaderService.hideLoader(context);
      ref.read(isLoadingProvider.notifier).state = false;

      if (response.statusCode == 200) {
        // Move to OTP verification step
        ref.read(currentStepProvider.notifier).state = 3;
      } else {
        _showErrorDialog("Registration failed. Please try again.");
      }
    } catch(error) {
      LoaderService.hideLoader(context);
      ref.read(isLoadingProvider.notifier).state = false;
      _handleError(error);
    }
  }

// A custom function to show the "Verification Successful" bottom sheet
  void showVerificationSuccessfulBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        // The content of the bottom sheet
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            // Makes the Column take up only the necessary space
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GifView.asset(
                'images/water.gif',
                height: 60,
                width: 60,
                frameRate: 30, // default is 15 FPS
              ),
              const SizedBox(height: 24),

              // Title Text
              const Text(
                'Verification Successful',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle/Body Text
              const Text(
                'Your account is all set up. Start exploring seamless transactions and features now.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              RoundedButton(
                  title: 'Next', onPressed: () {
                    Navigator.pushNamed(context, Login.id);
              })

            ],
          ),
        );
      },
    );
  }

  Future<void> verifyOTP() async {
    final dio = ref.read(dioProvider);


    if (_otpController.text.length != 6) {
      _showErrorDialog("Please enter a valid 6-digit OTP");
      return;
    }

    try {
      ref.read(isLoadingProvider.notifier).state = true;
      LoaderService.showLoader(context);

      final payload = {
        "email": _emailController.text,
        "otp": _otpController.text
      };

      final options = Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final response = await dio.post(
          '/auth/verify',
          data: jsonEncode(payload),
          options: options
      );

      LoaderService.hideLoader(context);
      ref.read(isLoadingProvider.notifier).state = false;

      if (response.statusCode == 200) {
        showVerificationSuccessfulBottomSheet(context);
      } else {
        _showErrorDialog("Verification failed. Please try again.");
      }
    } catch(error) {
      LoaderService.hideLoader(context);
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


  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentStepProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back button + progress
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  if (currentStep > 0)
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: isLoading ? null : () {
                            ref.read(currentStepProvider.notifier).state--;
                          },
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (currentStep + 1) / 4,
                      backgroundColor: const Color(0xFFE9EAEC),
                      color: AppColors.PRIMARYCOLOR,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Step content
            Expanded(
              child: _buildStep(context, ref, currentStep),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds different screens depending on step
  Widget _buildStep(BuildContext context, WidgetRef ref, int step) {
    switch (step) {
      case 0:
        return CreateUserName(controller: _usernameController);
      case 1:
        return CreateAccount(
          fullNameController: _fullNameController,
          phoneNumberController: _phoneNumberController,
          referralController: _referralController,
          hearAboutUsController: _hearAboutUsController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
        );
      case 2:
        return EmailAddress(
          controller: _emailController,
          onSubmit: submitForm,
        );
      case 3:
        return OTPScreen(
          controller: _otpController,
          email: _emailController.text,
          onVerify: verifyOTP,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class CreateUserName extends ConsumerWidget {
  final TextEditingController controller;
  const CreateUserName({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(usernameProvider);

    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create a username",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pick a name that represents your financial journey!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),

          LabeledTextField(
            label: "Username",
            hintText: "username",
            prefixIcon: Icons.person_outline,
            controller: controller,
            provider: usernameProvider,
          ),

          const Spacer(),

          RoundedButton(
            title: 'Next',
            onPressed: username == null || username.isEmpty
                ? null
                : () {
              ref.read(currentStepProvider.notifier).state++;
            },
            borderWidth: 0,
            color: username == null || username.isEmpty
                ? Colors.grey.shade200
                : AppColors.PRIMARYCOLOR,
          )
        ],
      ),
    );
  }
}

class CreateAccount extends ConsumerWidget {
  final TextEditingController fullNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController referralController;
  final TextEditingController hearAboutUsController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const CreateAccount({
    super.key,
    required this.fullNameController,
    required this.phoneNumberController,
    required this.referralController,
    required this.hearAboutUsController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullName = ref.watch(fullNameProvider);
    final phoneNumber = ref.watch(phoneNumberProvider);
    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);

    bool isFormValid = fullName != null &&
        fullName.isNotEmpty &&
        phoneNumber != null &&
        phoneNumber.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        confirmPassword != null &&
        confirmPassword.isNotEmpty;

    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create your PGOLD account to get started in minutes!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            LabeledTextField(
              label: "Full Name",
              hintText: "Enter Full Name",
              controller: fullNameController,
              provider: fullNameProvider,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 20),

            PhoneNumberField(
              controller: phoneNumberController,
              provider: phoneNumberProvider,
            ),
            const SizedBox(height: 20),

            LabeledTextField(
              label: "Password",
              hintText: "Enter Password",
              isPassword: true,
              controller: passwordController,
              provider: passwordProvider,
              prefixIcon: Icons.key,
            ),
            const SizedBox(height: 20),

            LabeledTextField(
              label: "Confirm Password",
              hintText: "Re-type Password",
              isPassword: true,
              controller: confirmPasswordController,
              provider: confirmPasswordProvider,
              prefixIcon: Icons.key,
            ),

            const SizedBox(height: 30),

            RoundedButton(
              title: 'Next',
              onPressed: isFormValid
                  ? () {
                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }
                ref.read(currentStepProvider.notifier).state++;
              }
                  : null,
              borderWidth: 0,
              color: isFormValid ? AppColors.PRIMARYCOLOR : Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }
}

class EmailAddress extends ConsumerWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const EmailAddress({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email Address",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Make sure you enter your details correctly!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),

          LabeledTextField(
            label: "Email Address",
            hintText: "name@example.com",
            prefixIcon: Icons.email_outlined,
            controller: controller,
            provider: emailProvider,
          ),

          const Spacer(),

          RoundedButton(
            title: isLoading ? 'Submitting...' : 'Next',
            onPressed: email == null || email.isEmpty || isLoading
                ? null
                : onSubmit,
            borderWidth: 0,
            color: (email == null || email.isEmpty || isLoading)
                ? Colors.grey.shade200
                : AppColors.PRIMARYCOLOR,
          )
        ],
      ),
    );
  }
}

class OTPScreen extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String email;
  final VoidCallback onVerify;

  const OTPScreen({
    super.key,
    required this.controller,
    required this.email,
    required this.onVerify,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  bool canResend = false;
  int resendCountdown = 120;
  Timer? _resendTimer;
  final FocusNode _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    setState(() {
      canResend = false;
      resendCountdown = 120;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (resendCountdown > 0) {
          resendCountdown--;
        } else {
          canResend = true;
          _resendTimer?.cancel();
        }
      });
    });
  }

  Future<void> resendOtp() async {
    final dio = ref.read(dioProvider);

    try {
      LoaderService.showLoader(context);

      Map<String, String> payload = {
        "email": widget.email,
      };

      final options = Options(headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

      final response = await dio.post(
          '/auth/verify/resend',
          data: jsonEncode(payload),
          options: options
      );

      if (!mounted) return;
      LoaderService.hideLoader(context);

      if (response.statusCode == 200) {
        _startResendCountdown();
        _showSuccessDialog('OTP sent successfully to ${widget.email}');
      } else {
        _showErrorDialog('Failed to resend OTP. Please try again.');
      }
    } on TimeoutException {
      if (!mounted) return;
      LoaderService.hideLoader(context);
      _showErrorDialog('Request timed out. Please try again.');
    } catch(error) {
      LoaderService.hideLoader(context);
      _handleResendError(error);
    }
  }

  void _handleResendError(dynamic error) {
    String errorMessage = "Failed to resend OTP. Please try again.";

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

  void _showSuccessDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
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

  void _onFocusChange() {
    if (_otpFocusNode.hasFocus) {
      // Ensure OTP field is visible when focused
      Future.delayed(const Duration(milliseconds: 300), () {
        Scrollable.ensureVisible(
          _otpFocusNode.context!,
          duration: const Duration(milliseconds: 300),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final otp = ref.watch(otpProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verify Email",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Before you continue, enter the 6 digit code sent to ${widget.email}!",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),

          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: widget.controller,
            focusNode: _otpFocusNode,
            obscureText: false,
            animationType: AnimationType.fade,
            textStyle: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontSize: 20
            ),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              fieldHeight: 50,
              fieldWidth: 50,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
              activeColor: const Color.fromRGBO(154, 154, 154, 0.5),
              inactiveColor: const Color.fromRGBO(154, 154, 154, 0.5),
              selectedColor: const Color.fromRGBO(154, 154, 154, 0.5),
            ),
            enableActiveFill: true,
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              ref.read(otpProvider.notifier).state = value;
            },
            onCompleted: (value) {
              // Auto-verify when OTP is complete
              if (value.length == 6 && !isLoading) {
                widget.onVerify();
              }
            },
            beforeTextPaste: (text) => true,
          ),

          const SizedBox(height: 20),

          // Resend OTP section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: canResend && !isLoading ? resendOtp : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: canResend && !isLoading
                          ? AppColors.PRIMARYCOLOR
                          : Colors.grey, size: 12,),
                      Text(
                        canResend
                            ? 'Resend Code'
                            : 'Resend Code ${resendCountdown}s',
                        style: TextStyle(
                          color: canResend && !isLoading
                              ? AppColors.PRIMARYCOLOR
                              : Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          RoundedButton(
            title: isLoading ? 'Verifying...' : 'Verify OTP',
            onPressed: (otp == null || otp.length != 6 || isLoading)
                ? null
                : widget.onVerify,
            borderWidth: 0,
            color: (otp == null || otp.length != 6 || isLoading)
                ? Colors.grey.shade200
                : AppColors.PRIMARYCOLOR,
          )
        ],
      ),
    );
  }
}