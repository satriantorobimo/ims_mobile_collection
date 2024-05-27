import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingComp extends StatelessWidget {
  const LoadingComp({super.key, required this.height, required this.padding});
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.only(top: padding),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
          width: double.infinity,
          height: height,
        ),
      ),
    );
  }
}
