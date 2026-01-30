import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountryShimmerList extends StatelessWidget {
  const CountryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Define shimmer colors based on theme
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
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flag placeholder
                Container(
                  width: 100,
                  height: 80,
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
                    children: [
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: shimmerContentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: shimmerContentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Favorite icon placeholder
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