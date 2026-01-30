import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesShimmerList extends StatelessWidget {
  const FavoritesShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final Color baseColor = isDark 
        ? Colors.grey[800]!
        : Colors.grey[300]!;
    
    final Color highlightColor = isDark
        ? Colors.grey[600]!
        : Colors.grey[100]!;
    
    final Color shimmerContentColor = isDark
        ? Colors.grey[700]!
        : Colors.white;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flag placeholder
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: shimmerContentColor,
                  ),
                ),
                const SizedBox(width: 16),
                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 18,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: shimmerContentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: shimmerContentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Remove button placeholder
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: shimmerContentColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}