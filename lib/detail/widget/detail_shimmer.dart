import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountryDetailShimmer extends StatelessWidget {
  const CountryDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flag placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            
            
            // Section title placeholder
            Container(
              width: 150,
              height: 24,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            
            // Statistics grid placeholder
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 6.0,
              mainAxisSpacing: 10,
              crossAxisSpacing: 12,
              children: List.generate(4, (index) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 14,
                      color: Colors.white,
                    ),
                    Container(
                      width: 60,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              )),
            ),
            
            const SizedBox(height: 24),
            
            // Capital section placeholder
            _buildDetailRowShimmer(),
            
            const SizedBox(height: 24),
            
            // Timezones section title
            Container(
              width: 120,
              height: 24,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            
            // Timezones chips placeholder
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(3, (index) => Container(
                width: 100,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRowShimmer() {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 14,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 4),
            ),
            Container(
              width: 100,
              height: 18,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

// Compact shimmer for list view
class DetailCardShimmer extends StatelessWidget {
  const DetailCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}