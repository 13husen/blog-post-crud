import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int totalPosts;
  final int totalWords;

  const StatsCard({
    super.key,
    required this.totalPosts,
    required this.totalWords,
  });

  @override
  Widget build(BuildContext context) {
    final avgWords = totalPosts > 0 ? (totalWords / totalPosts).round() : 0;

    TextStyle labelStyle = const TextStyle(color: Colors.white, fontSize: 14);
    TextStyle valueStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    Widget buildRow(IconData icon, String label, String value) {
      return Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text('$label: ', style: labelStyle),
          Text(value, style: valueStyle),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Blog Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            buildRow(Icons.article, 'Total Posts', '$totalPosts'),
            const SizedBox(height: 8),
            buildRow(Icons.text_fields, 'Total Words', '$totalWords'),
            const SizedBox(height: 8),
            buildRow(Icons.equalizer, 'Avg. Words/Post', '$avgWords'),
          ],
        ),
      ),
    );
  }
}
