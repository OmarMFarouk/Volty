import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({
    super.key,
    this.title = 'فترة الذروة',
    this.subTitle =
        'الآن في وقت الذروة (2:00 م - 5:00 م)\nالتعرفة مرتفعة بنسبة 30%',
  });
  final String title, subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B6B).withOpacity(0.2),
            const Color(0xFFFF8E53).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: const Color(0xFFFF6B6B),
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.grey[300], fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
