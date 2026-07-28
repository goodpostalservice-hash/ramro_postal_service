import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_exports.dart';
import '../../core/constants/const_keys.dart';
import '../../core/storage/storage_util.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool _isNavigating = false;

  static const List<OnboardingData> _pages = [
    OnboardingData(
      imagePath: 'assets/images/slide_1.png',
      title: 'Save your recent address',
      description: 'Your location still works—even when you’re offline.',
    ),
    OnboardingData(
      imagePath: 'assets/images/slide_2.png',
      title: 'Share a Simple Delivery Code',
      description: 'Use a short location code instead of a full address.',
    ),
    OnboardingData(
      imagePath: 'assets/images/slide_3.jpg',
      title: 'Track & Receive Without Guesswork',
      description: 'Know exactly where your parcel is—and when it will arrive.',
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _onNext() {
    if (!_isLastPage) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      await SStorageUtil.saveData(key: SConstKeys.isWelcomed, value: true);
      if (mounted) {
        Get.offAllNamed(AppRoutes.selectRole);
      }
    } catch (_) {
      _isNavigating = false;
      rethrow;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  if (_currentPage != index) {
                    setState(() => _currentPage = index);
                  }
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            page.imagePath,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.headlineMedium_32_600,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.bodyLargeGray_16_500
                                  .copyWith(color: appTheme.gray900),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? appTheme.orangeBase
                        : appTheme.gray200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    label: _isLastPage ? 'Get Started' : 'Continue',
                    onPressed: _onNext,
                    height: 48,
                  ),
                  if (!_isLastPage) ...[
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Skip',
                      onPressed: _completeOnboarding,
                      variant: AppButtonVariant.outlined,
                      height: 48,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  const OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;
}
