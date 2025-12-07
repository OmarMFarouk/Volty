import 'package:flutter/material.dart';

class ActionsCard extends StatelessWidget {
  const ActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجراءات سريعة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'وضع التوفير',
                Icons.eco_rounded,
                const Color(0xFF4ECDC4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'جدولة الأجهزة',
                Icons.schedule_rounded,
                const Color(0xFFB8FF57),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'تنبيهات الطاقة',
                Icons.notifications_active_rounded,
                const Color(0xFFFFB84D),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'الطاقة الشمسية',
                Icons.solar_power_rounded,
                const Color(0xFFFF6B6B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
        ],
      ),
    );
  }
}
