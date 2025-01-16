import 'package:connect_with/main.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart' ;
import 'package:shimmer/shimmer.dart';

class OrganizationCardShimmerEffect extends StatelessWidget {
  const OrganizationCardShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 1,
              child: Container(
                // height: 100,
                decoration: BoxDecoration(
                  color: AppColors.theme['secondaryColor'],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Shimmer Circle
                      Shimmer.fromColors(
                        baseColor: AppColors.theme['primaryColor']!.withOpacity(0.3),
                        highlightColor:
                        AppColors.theme['backgroundColor']!.withOpacity(0.1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Shimmer Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Shimmer.fromColors(
                              baseColor: AppColors.theme['primaryColor']!.withOpacity(0.3),
                              highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.1),
                              child: Container(
                                height: 20,
                                width: mq.width * 0.6,
                                color: AppColors.theme['primaryColor']!.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Shimmer.fromColors(
                              baseColor: AppColors.theme['primaryColor']!.withOpacity(0.3),
                              highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.1),
                              child: Container(
                                height: 15,
                                width: mq.width * 0.4,
                                color: AppColors.theme['primaryColor']!.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5,)
          ],
        );
      },
    );
  }
}

