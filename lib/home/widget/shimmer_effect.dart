import 'package:countries/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountryShimmerList extends StatelessWidget {
  const CountryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorResources.grey300Color,
      highlightColor: ColorResources.grey100Color,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading:  Container(
              width: 100,
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: ColorResources.grey100Color,
    ),
            ),
            title: Container(
              height: 16,
              width: 100,
              color: ColorResources.whiteColor,
            ),
            subtitle: Container(
              height: 12,
              width: 80,
              color: ColorResources.whiteColor,
            ),
            trailing: const Icon(Icons.favorite_border),
          );
        },
      ),
    );
  }
}