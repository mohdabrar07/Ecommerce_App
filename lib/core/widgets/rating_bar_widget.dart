import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final double rate;
  final int count;

  const RatingBarWidget({
    super.key,
    required this.rate,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // Round down to find the number of full stars to draw
    int fullStars = rate.floor();
    // Check if there is a remainder large enough to qualify for a half-star
    bool hasHalfStar = (rate - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Generate the 5-star evaluation track row
        Row(
          children: List.generate(5, (index) {
            if (index < fullStars) {
              return const Icon(Icons.star, color: Colors.amber, size: 18);
            } else if (index == fullStars && hasHalfStar) {
              return const Icon(Icons.star_half, color: Colors.amber, size: 18);
            } else {
              return const Icon(Icons.star_border, color: Colors.amber, size: 18);
            }
          }),
        ),
        const SizedBox(width: 6),
        // Numerical value and review metrics display tag
        Text(
          "${rate.toStringAsFixed(1)} ($count reviews)",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}