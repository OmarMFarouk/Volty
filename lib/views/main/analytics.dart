import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _aiController;

  @override
  void initState() {
    super.initState();
    _aiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    'التحليلات والتقارير',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'نظرة تفصيلية على استهلاكك',
                    style: TextStyle(color: Colors.grey[400], fontSize: 15),
                  ),
                ],
              ),
              _buildAIPredictionCard(),
              _buildPeriodSelector(),
              _buildTotalConsumptionCard(),
              _buildCostBreakdown(),
              _buildPeakUsageCard(),
              _buildDeviceConsumptionRanking(),
              _buildSavingsSuggestions(),
              SizedBox(height: kToolbarHeight * 1.5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIPredictionCard() {
    return AnimatedBuilder(
      animation: _aiController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(
                  0xFF6C63FF,
                ).withOpacity(0.9 + (_aiController.value * 0.1)),
                const Color(
                  0xFF5B54E8,
                ).withOpacity(0.8 + (_aiController.value * 0.1)),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF6C63FF,
                ).withOpacity(0.3 + (_aiController.value * 0.2)),
                blurRadius: 25 + (_aiController.value * 5),
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(
                            0.1 * _aiController.value,
                          ),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'توقعات الذكاء الاصطناعي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تحليل بناءً على آخر 90 يوم',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8FF57),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '94% دقة',
                      style: TextStyle(
                        color: const Color(0xFF0A0E1A),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'استهلاك متوقع للشهر القادم',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '695',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      ' ك.و',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: const Color(0xFFFF6B6B),
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+1.2%',
                                style: TextStyle(
                                  color: const Color(0xFFFF6B6B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'التكلفة المتوقعة',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '610 ج.م',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'توفير محتمل',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '127 ج.م',
                                style: TextStyle(
                                  color: const Color(0xFFB8FF57),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.insights, color: Colors.white, size: 18),
                label: Text(
                  'عرض التفاصيل الكاملة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildPeriodButton('يوم', false)),
          Expanded(child: _buildPeriodButton('أسبوع', false)),
          Expanded(child: _buildPeriodButton('شهر', true)),
          Expanded(child: _buildPeriodButton('سنة', false)),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFB8FF57).withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? const Color(0xFFB8FF57) : Colors.grey[400],
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTotalConsumptionCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF4ECDC4), const Color(0xFF44A0A8)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الاستهلاك',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.trending_down, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '687',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  ' ك.و',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '12.5% أقل من الشهر السابق',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل التكلفة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildCostItem('التعرفة الأساسية', 458.50, const Color(0xFFB8FF57)),
          const SizedBox(height: 12),
          _buildCostItem('تعرفة الذروة', 186.20, const Color(0xFFFF6B6B)),
          const SizedBox(height: 12),
          _buildCostItem('خصم الطاقة الشمسية', -42.80, const Color(0xFF4ECDC4)),
          const SizedBox(height: 15),
          Divider(color: const Color(0xFF2D3548), thickness: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '601.90 ج.م',
                style: TextStyle(
                  color: const Color(0xFFB8FF57),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostItem(String label, double amount, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} ج.م',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPeakUsageCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أوقات الاستهلاك العالي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.access_time, color: const Color(0xFFFFB84D)),
            ],
          ),
          const SizedBox(height: 20),
          _buildPeakTimeItem(
            '2:00 م - 5:00 م',
            'ذروة عالية',
            4.8,
            const Color(0xFFFF6B6B),
          ),
          const SizedBox(height: 12),
          _buildPeakTimeItem(
            '8:00 م - 11:00 م',
            'ذروة متوسطة',
            3.5,
            const Color(0xFFFFB84D),
          ),
          const SizedBox(height: 12),
          _buildPeakTimeItem(
            '6:00 ص - 9:00 ص',
            'استهلاك منخفض',
            2.1,
            const Color(0xFF4ECDC4),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakTimeItem(
    String time,
    String level,
    double kwh,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E1A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.schedule, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(level, style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '$kwh ك.و',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceConsumptionRanking() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأجهزة الأكثر استهلاكاً',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildDeviceRankItem(
            1,
            'مكيف الهواء',
            Icons.ac_unit_rounded,
            285.4,
            41.5,
            const Color(0xFFB8FF57),
          ),
          const SizedBox(height: 12),
          _buildDeviceRankItem(
            2,
            'سخان الماء',
            Icons.water_drop_rounded,
            156.8,
            22.8,
            const Color(0xFF4ECDC4),
          ),
          const SizedBox(height: 12),
          _buildDeviceRankItem(
            3,
            'الثلاجة',
            Icons.kitchen_rounded,
            98.5,
            14.3,
            const Color(0xFFFFB84D),
          ),
          const SizedBox(height: 12),
          _buildDeviceRankItem(
            4,
            'غسالة الملابس',
            Icons.local_laundry_service_rounded,
            76.2,
            11.1,
            const Color(0xFFFF6B6B),
          ),
          const SizedBox(height: 12),
          _buildDeviceRankItem(
            5,
            'الإضاءة',
            Icons.lightbulb_rounded,
            70.8,
            10.3,
            Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRankItem(
    int rank,
    String name,
    IconData icon,
    double kwh,
    double percentage,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E1A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? color.withOpacity(0.2)
                  : const Color(0xFF2D3548),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3 ? color : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${kwh.toStringAsFixed(1)} ك.و',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsSuggestions() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8FD63F).withOpacity(0.2),
            const Color(0xFFB8FF57).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFB8FF57).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8FF57).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: const Color(0xFFB8FF57),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'توصيات للتوفير',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSuggestionItem(
            'رفع درجة حرارة المكيف إلى 24°',
            'يمكنك توفير 85 ج.م شهرياً',
            Icons.thermostat_rounded,
          ),
          const SizedBox(height: 12),
          _buildSuggestionItem(
            'جدولة سخان الماء لأوقات خارج الذروة',
            'يمكنك توفير 62 ج.م شهرياً',
            Icons.schedule_rounded,
          ),
          const SizedBox(height: 12),
          _buildSuggestionItem(
            'استخدام الإضاءة الذكية مع مستشعرات الحركة',
            'يمكنك توفير 28 ج.م شهرياً',
            Icons.sensors_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String title, String savings, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFB8FF57).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFB8FF57), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  savings,
                  style: TextStyle(
                    color: const Color(0xFFB8FF57),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
        ],
      ),
    );
  }
}
