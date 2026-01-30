import 'package:flutter/material.dart';

import '../../utils/color_resources.dart';
import '../../utils/style.dart';

class StatisticWidget extends StatelessWidget {
  final String title;
  final String value;


  const StatisticWidget({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: robotoLight.copyWith(color: ColorResources.grey600Color)
        ),
      
        Text(
          value,
          style:robotoLight,
        ),
      ],
    );
  }
}