import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connect_with/utils/theme/colors.dart';

class ExperienceCardShimmerEffect extends StatelessWidget {
  const ExperienceCardShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      padding:  EdgeInsets.all(12),
      margin:  EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.theme['secondaryColor']?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company name and logo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.theme['backgroundColor'],
                ),
              ),
               SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                      highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                      child: Container(
                        height: 20,
                        width: mq.width * 0.7,
                        color: Colors.grey,
                      ),
                    ),
                     SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                      highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                      child: Container(
                        height: 20,
                        width: mq.width * 0.3,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           SizedBox(height: 10),
          Padding(
            padding:  EdgeInsets.only(left: mq.width*0.12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                  child: Container(
                    height: 20,
                    width: mq.width * 0.5,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                  child: Container(
                    height: 20,
                    width: mq.width * 0.65,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                  child: Container(
                    height: 20,
                    width: mq.width * 0.4,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      3,
                          (index) => Container(
                        height: 20,
                        width: mq.width * 0.2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceCardListView extends StatelessWidget {
  const ExperienceCardListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 2, // Number of items in the list
      itemBuilder: (context, index) {
        return const ExperienceCardShimmerEffect();
      },
    );
  }
}
