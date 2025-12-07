import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.showSubtitle,
    required this.icon,
    required this.title,
    this.subTitle,
  });
  final IconData icon;
  final String title;
  final String? subTitle;
  final bool? showSubtitle;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'لا يوجد ${title.replaceAll('ال', '')}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (showSubtitle == null)
            Text(
              subTitle ?? 'جرب تغيير معايير البحث',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
        ],
      ),
    );
  }
}
