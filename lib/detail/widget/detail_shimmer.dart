import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountryDetailShimmer extends StatelessWidget {
  const CountryDetailShimmer({super.key});

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flag placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: shimmerContentColor,
              ),
            ),
            const SizedBox(height: 24),
            // Title placeholder
            Container(
              height: 24,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: shimmerContentColor,
              ),
            ),
            const SizedBox(height: 16),
            // Statistics grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 6.0,
              mainAxisSpacing: 10,
              crossAxisSpacing: 12,
              children: List.generate(4, (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: shimmerContentColor,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: baseColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 20,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: baseColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Timezones title
            Container(
              height: 24,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: shimmerContentColor,
              ),
            ),
            const SizedBox(height: 12),
            // Timezone chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(3, (index) {
                return Container(
                  width: 80,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: shimmerContentColor,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}