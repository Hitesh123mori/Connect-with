import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserCardShimmerEffect extends StatelessWidget {
  const UserCardShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Shimmer Circle for Profile Picture
              Shimmer.fromColors(
                baseColor: AppColors.theme['primaryColor']!.withOpacity(0.3),
                highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.1),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 15),
              // Shimmer Text for User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor']!.withOpacity(0.3),
                      highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.1),
                      child: Container(
                        height: 15,
                        width: double.infinity,
                        color: AppColors.theme['primaryColor']!.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor']!.withOpacity(0.3),
                      highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.1),
                      child: Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: AppColors.theme['primaryColor']!.withOpacity(0.4),
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
