import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserCardShimmerEffect extends StatelessWidget {
  const UserCardShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, // Keeping it minimal for smooth UX
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              // **Profile Picture Shimmer**
              Shimmer.fromColors(
                baseColor: AppColors.theme['primaryColor']!.withOpacity(0.2),
                highlightColor: AppColors.theme['primaryColor']!.withOpacity(0.5),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.theme['primaryColor']!.withOpacity(0.4),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // **User Info Shimmer**
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // **Username Placeholder**
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor']!.withOpacity(0.2),
                      highlightColor: AppColors.theme['primaryColor']!.withOpacity(0.5),
                      child: Container(
                        height: 16,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor']!.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // **User Headline Placeholder**
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor']!.withOpacity(0.2),
                      highlightColor: AppColors.theme['primaryColor']!.withOpacity(0.5),
                      child: Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor']!.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
