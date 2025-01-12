import 'package:connect_with/main.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class JobCardShimmerEffect extends StatefulWidget {
  const JobCardShimmerEffect({super.key});

  @override
  State<JobCardShimmerEffect> createState() => _JobCardShimmerEffectState();
}

class _JobCardShimmerEffectState extends State<JobCardShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Container(
            height: 150,
            width: mq.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  highlightColor:
                      AppColors.theme['backgroundColor']!.withOpacity(0.1),
                  child: CircleAvatar(
                    backgroundColor: AppColors.theme['secondaryColor'],
                    radius: 40,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor:
                              AppColors.theme['primaryColor'].withOpacity(0.1),
                          highlightColor: AppColors.theme['backgroundColor']
                              .withOpacity(0.1),
                          child: Container(
                            height: 20,
                            width: mq.width * 0.5,
                            decoration: BoxDecoration(
                              color: AppColors.theme['primaryColor'],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                      highlightColor: AppColors.theme['backgroundColor']
                          .withOpacity(0.1),
                      child: Container(
                        height: 20,
                        width: mq.width * 0.45,
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor'],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                      highlightColor: AppColors.theme['backgroundColor']
                          .withOpacity(0.1),
                      child: Container(
                        height: 20,
                        width: mq.width * 0.7,
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor'],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                      highlightColor: AppColors.theme['backgroundColor']
                          .withOpacity(0.1),
                      child: Container(
                        height: 20,
                        width: mq.width * 0.15,
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor'],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Shimmer.fromColors(
                      baseColor: AppColors.theme['primaryColor'].withOpacity(0.1),
                      highlightColor: AppColors.theme['backgroundColor']
                          .withOpacity(0.1),
                      child: Container(
                        height: 20,
                        width: mq.width * 0.2,
                        decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor'],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
