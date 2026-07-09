import 'package:respilink_mobile/features/onboarding/data/onboarding_local_manager.dart';

import '../../../../exports.dart';

class _OnboardingSlide {
  final String image;
  final String title;
  final String subtitle;

  const _OnboardingSlide({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

const List<_OnboardingSlide> _slides = [
  _OnboardingSlide(
    image: 'respiratory.png',
    title: 'Stay Connected',
    subtitle:
        'Discover webinars, conferences and workshops curated for respiratory specialists worldwide.',
  ),
  _OnboardingSlide(
    image: 'take_quiz.png',
    title: 'Compete & Learn',
    subtitle:
        'Test your expertise in time-bound quizzes and climb the leaderboard among your peers.',
  ),
  _OnboardingSlide(
    image: 'copd.png',
    title: 'Learn anywhere',
    subtitle:
        'Access our scientific library on the go and stay updated with the latest research.',
  ),
];

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _slides.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    if (_isLastPage) {
      await locator<OnboardingLocalManager>().markOnboardingSeen();
      locator<NavigationService>().navigateAndRemove(RouterStrings.register);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _onLogin() async {
    await locator<OnboardingLocalManager>().markOnboardingSeen();
    locator<NavigationService>().navigateAndRemove(RouterStrings.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) => _SlideContent(
                    slide: _slides[index],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              /// Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: index == _currentPage ? 24.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? AppColors.primary
                          : AppColors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              AppButton.filled(
                label: _isLastPage ? 'Get Started  →' : 'Next  →',
                onTap: _onGetStarted,
              ),

              SizedBox(height: 16.h),

              Center(
                child: GestureDetector(
                  onTap: _onLogin,
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: AppConstants.fontFamily,
                        color: AppColors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppConstants.fontFamily,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideContent extends StatelessWidget {
  final _OnboardingSlide slide;

  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: AppNetworkImage(
            imageUrl: "${AppConstants.imagePath}${slide.image}",
            width: double.infinity,
            height: .45.sh,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 28.h),
        AppText.large(
          label: slide.title,
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 10.h),
        AppText.small(
          label: slide.subtitle,
          color: AppColors.grey,
          textAlign: TextAlign.center,
          fontSize: 15.sp,
        ),
      ],
    );
  }
}
