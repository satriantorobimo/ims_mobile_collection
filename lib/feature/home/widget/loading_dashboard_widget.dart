import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingDashboardWidget extends StatelessWidget {
  const LoadingDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade300,
                ),
                width: 100,
                height: 18,
              ),
            )),
        const SizedBox(
          height: 17,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: 180,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: 180,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade300,
                ),
                width: 100,
                height: 18,
              ),
            )),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
