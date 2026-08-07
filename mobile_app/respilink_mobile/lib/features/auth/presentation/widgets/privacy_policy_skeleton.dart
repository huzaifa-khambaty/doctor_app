import '../../../../exports.dart';

/// Matches [PrivacyPolicyView]'s title -> updated-date -> body-paragraphs
/// layout so the loading state doesn't jump when the response arrives.
class PrivacyPolicySkeleton extends StatelessWidget {
  const PrivacyPolicySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton.textBar(width: 220.w, height: 20.h),
          SizedBox(height: 10.h),
          AppSkeleton.textBar(width: 130.w, height: 12.h),
          SizedBox(height: 24.h),
          for (var i = 0; i < 10; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: AppSkeleton.textBar(
                width: i % 3 == 2 ? 220.w : double.infinity,
                height: 13.h,
              ),
            ),
        ],
      ),
    );
  }
}
