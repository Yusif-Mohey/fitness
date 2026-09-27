import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  const new({
    super.key,
    required this.isDark,
    required this.progressValue,
    required this.total,
    required this.targetDaily,
    required this.type,
  });

  final bool isDark;
  final double progressValue;
  final int total;
  final int targetDaily;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Progress',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 12,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$total / $targetDaily $type',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: isDark ? Colors.white70 : Colors.black54),
          ),
        ],
      ),
    );
  }
}
