import '../../../../exports.dart';

class RankingsSectionHeader extends StatelessWidget {
  final VoidCallback? onAllSpecialtiesTap;

  const RankingsSectionHeader({super.key, this.onAllSpecialtiesTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.medium(
          label: 'Rankings',
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        GestureDetector(
          onTap: onAllSpecialtiesTap,
          child: AppText.small(
            label: 'All specialties',
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
