import 'package:countries/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesShimmerList extends StatelessWidget {
  const FavoritesShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorResources.grey300Color,
      highlightColor: ColorResources.grey100Color,
      child: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return _buildShimmerFavoriteItem();
        },
      ),
    );
  }

  Widget _buildShimmerFavoriteItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flag placeholder
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.whiteColor,
            ),
            ),
          const SizedBox(width: 16),
          // Content placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 18,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 6),
                ),
                Container(
                  width: 100,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          // Remove button placeholder
          Container(
            width: 40,
            height: 40,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class FavoritesEmptyShimmer extends StatelessWidget {
  const FavoritesEmptyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.whiteColor,
            ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 200,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Container(
              width: 250,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}