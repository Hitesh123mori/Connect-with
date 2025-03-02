import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostCardShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: 460,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildShimmerCircle(size: 40),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShimmerBox(width: 120, height: 15),
                          SizedBox(height: 5),
                          _buildShimmerBox(width: 80, height: 12),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildShimmerBox(width: double.infinity, height: 18),
                  SizedBox(height: 5),
                  _buildShimmerBox(width: double.infinity, height: 18),
                  SizedBox(height: 5),
                  _buildShimmerBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 18),
                  SizedBox(height: 10),
                  _buildShimmerBox(
                      width: double.infinity, height: 200, borderRadius: 10),
                  SizedBox(height: 10),
                  _buildShimmerBox(width: 100, height: 30),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShimmerBox(width: 78, height: 35, borderRadius: 5),
                      _buildShimmerBox(width: 78, height: 35, borderRadius: 5),
                      _buildShimmerBox(width: 78, height: 35, borderRadius: 5),
                      _buildShimmerBox(width: 78, height: 35, borderRadius: 5),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildShimmerBox(
      {double width = 100, double height = 20, double borderRadius = 8}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade500,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildShimmerCircle({double size = 40}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
