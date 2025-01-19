import 'package:connect_with/main.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProjectCardShimmerEffect extends StatefulWidget {
  const ProjectCardShimmerEffect({super.key});

  @override
  State<ProjectCardShimmerEffect> createState() =>
      _ProjectCardShimmerEffectState();
}

class _ProjectCardShimmerEffectState extends State<ProjectCardShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer for Title
          Shimmer.fromColors(
            baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
            highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
            child: Container(
              height: 20,
              width: mq.width * 0.4,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 5,),
          // Shimmer for Subtitle
          Shimmer.fromColors(
            baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
            highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
            child: Container(
              height: 20,
              width: mq.width * 0.7,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 10),
          // Shimmer for Button
          Shimmer.fromColors(
            baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
            highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
            child: Container(
              width: 150,
              color: AppColors.theme['backgroundColor'],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                        highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                        child: Container(
                          height: 10,
                          width: 50,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 5),
                      Shimmer.fromColors(
                        baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                        highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                        child: Container(
                          height: 10,
                          width: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Shimmer for Skills
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
          // Shimmer for User Avatars
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                       Padding(
                        padding:  EdgeInsets.only(right: 8.0),
                        child: Shimmer.fromColors(
                          baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                          highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.theme['backgroundColor'],
                                radius: 20,
                              ),
                              SizedBox(width: 5,),
                              CircleAvatar(
                                backgroundColor: AppColors.theme['backgroundColor'],
                                radius: 20,
                              ),
                              SizedBox(width: 5,),
                              CircleAvatar(
                                backgroundColor: AppColors.theme['backgroundColor'],
                                radius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),


                  ],
                ),
              ],
            ),
          // Shimmer for Cover Image
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  highlightColor: AppColors.theme['backgroundColor']!.withOpacity(0.2),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.theme['backgroundColor']
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
