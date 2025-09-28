import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pgold/components/rounded_button.dart';
import 'package:pgold/screens/onboarding/auth/login.dart';
import 'package:pgold/utils/appcolors.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});
  static String id = 'onboard_screen';

  @override
  State<Onboard> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<Onboard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  final List<Map<String, dynamic>> slides = [
    {
      'title': 'Purchase and Trade Giftcards Effortlessly',
      'subtitle': 'Access the best deals on top-brand giftcards. Buy, Sell, or redeem instantly-no hassles, just value.',
      'image_widget': 'images/intro1.png',
    },
    {
      'title': 'Secure Payments with Virtual Dollar Cards',
      'subtitle': 'Create and manage virtual cards for safe and flexible online transactions. Control your spendings with just few taps.',
      'image_widget': 'images/intro2.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (slides.isNotEmpty) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      int nextPage = (_currentPage + 1) % slides.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        if (mounted) {
          setState(() {
            _currentPage = nextPage;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Login.id);
              },
              style: TextButton.styleFrom(
                side:  const BorderSide(color: AppColors.PRIMARYCOLOR, width: 1.5), // Blue border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(31), // Optional rounded corners
                ),
              ),
              child:  const Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.PRIMARYCOLOR,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            right: _currentPage == 0 ? -70 : 0,
            bottom: MediaQuery.of(context).size.height * 0.45,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: slides.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Image.asset(slides[index]['image_widget']),
                );
              },
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    slides[_currentPage]['title']!,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 27, // Slightly larger for emphasis
                      color: Colors.black, // Dark text color
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Text(
                    slides[_currentPage]['subtitle']!,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF718096), // Muted text color
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Page Indicator Dots
                  _buildPageIndicator(),
                  const SizedBox(height: 40),
                  // Next Button
                  RoundedButton(
                      title: 'Next',
                      onPressed: () {
                        if (_currentPage < slides.length - 1) {
                          // Go to the next slide
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushNamed(context, Login.id);
                        }
                      }
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(slides.length, (index) {
        bool isCurrent = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: isCurrent ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.PRIMARYCOLOR : Colors.blue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

}