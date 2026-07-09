import '../../../../exports.dart';

class PodiumItemWidget extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final String imageUrl;
  final double podiumHeight;
  final List<Color> gradientColors;
  final bool isFirstPlace;

  const PodiumItemWidget({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.imageUrl,
    required this.podiumHeight,
    required this.gradientColors,
    this.isFirstPlace = false,
  });

  @override
  Widget build(BuildContext context) {
    // Styling variables based on rank
    final Color rankColor = isFirstPlace 
        ? const Color(0xFFFFAE34) 
        : (rank == 2 ? const Color(0xFF94A3B8) : const Color(0xFFC6926F));
        
    final Color nameColor = isFirstPlace ? const Color(0xFF0F4C5C) : const Color(0xFF1E293B);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Avatar Stack (Image + Rank Badge + Star Badge if 1st)
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Profile Image with Border
              Container(
                width: isFirstPlace ? 84.r : 72.r,
                height: isFirstPlace ? 84.r : 72.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: rankColor,
                    width: isFirstPlace ? 3.r : 2.r,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: AppNetworkImage(imageUrl: imageUrl), // Your custom image widget
                ),
              ),
              
              // Top Star badge for 1st place
              if (isFirstPlace)
                Positioned(
                  top: -10.h,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFAE34),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 12.r,
                    ),
                  ),
                ),
                
              // Bottom Right Rank Number Badge
              Positioned(
                bottom: -2.h,
                right: isFirstPlace ? 2.w : -2.w,
                child: Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    color: rankColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5.r),
                  ),
                  alignment: Alignment.center,
                  child: AppText.small(
                    label: '$rank',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          
          // Podium Bar Container
          Container(
            height: podiumHeight.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.large(
                  label: points,
                  color: const Color(0xFF0F4C5C),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
                SizedBox(height: 2.h),
                AppText.small(
                  label: 'PTS',
                  color: const Color(0xFF0F4C5C).withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          
          // Doctor Name Below the Podium
          AppText.medium(
            label: name,
            color: nameColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}