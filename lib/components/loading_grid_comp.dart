import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingGridComp extends StatelessWidget {
  const LoadingGridComp(
      {super.key, required this.height, required this.length});

  final double height;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                width: double.infinity,
                height: height,
              );
            }));
  }
}
