import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/components/general/refresh.dart';
import 'package:volty/src/app_localization.dart';
import 'package:volty/src/app_string.dart';
import '../../blocs/analytics_bloc/cubit.dart';
import '../../blocs/analytics_bloc/states.dart';
import '../../src/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnalyticsCubit, AnalyticsStates>(
      listener: (context, state) {
        if (state is AnalyticsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.msg), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        var cubit = AnalyticsCubit.get(context);

        if (state is AnalyticsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SafeArea(
          child: CustomRefresh(
            onRefresh: () => cubit.fetchAnalytics(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    // _buildAIPredictionCard(),
                    _buildPeriodSelector(cubit),
                    _buildTotalConsumptionCard(cubit, context),
                    _buildCostBreakdown(cubit),
                    _buildPeakUsageCard(cubit, context),
                    _buildDeviceConsumptionRanking(cubit),
                    // _buildSavingsSuggestions(),
                    const SizedBox(height: kToolbarHeight * 1.5),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          AppString.analyticsTitle.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppString.analyticsSubtitle.tr(),
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(AnalyticsCubit cubit) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Row(
        children: [
          _buildPeriodButton(
            AppString.day,
            cubit.selectedPeriod == 'day',
            cubit,
          ),
          _buildPeriodButton(
            AppString.week,
            cubit.selectedPeriod == 'week',
            cubit,
          ),
          _buildPeriodButton(
            AppString.month,
            cubit.selectedPeriod == 'month',
            cubit,
          ),
          _buildPeriodButton(
            AppString.year,
            cubit.selectedPeriod == 'year',
            cubit,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    String label,
    bool isSelected,
    AnalyticsCubit cubit,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.changePeriod(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey[400],
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalConsumptionCard(
    AnalyticsCubit cubit,
    BuildContext context,
  ) {
    var model = cubit.analyticsModel;
    var consumption = model?.consumption;
    var comparison = consumption?.comparison;

    double total = ((consumption?.currentPeriodTotal ?? 0) / 1000);
    bool isIncrease = comparison?.isIncrease ?? false;
    double percentage = comparison?.percentage ?? 0;
    String periodText = comparison?.periodText ?? AppString.recentPeriod.tr();

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
                AppString.consumptionTotal.tr(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                isIncrease ? Icons.trending_up : Icons.trending_down,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                total.toStringAsFixed(3),
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
                  ' ${AppString.unitK.tr()}',
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
                    Icon(
                      isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${percentage > 9999 ? 9999 : percentage.toStringAsFixed(1)}${percentage > 9999 ? "+" : ""}% ${isIncrease ? AppString.moreThan.tr() : AppString.lessThan.tr()} ${AppLocalization.isArabic(context)
                          ? periodText
                          : periodText.contains('اليوم')
                          ? "Previous Day"
                          : periodText.contains('الأسبوع')
                          ? "Previous Week"
                          : periodText.contains('الشهر')
                          ? "Previous Month"
                          : periodText.contains('السنة')
                          ? "Previous Year"
                          : "Previous Period"}',
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

  Widget _buildCostBreakdown(AnalyticsCubit cubit) {
    var model = cubit.analyticsModel;
    var pricing = model?.pricing;
    var tiers = pricing?.tiers ?? [];
    double currentTotal = pricing?.currentTotal ?? 0;
    double previousTotal = pricing?.previousTotal ?? 0;
    String periodText = model!.consumption!.comparison!.periodText!;
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
            AppString.costBreakdown.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (tiers.isNotEmpty) const SizedBox(height: 20),
          ...tiers.map(
            (tier) => _buildCostItem(
              tier.tierName ?? '',
              tier.cost ?? 0,
              AppColors.tiersColors[tiers.indexOf(tier)],
              tier.consumption ?? 0,
              tier.rate ?? 0,
            ),
          ),
          const SizedBox(height: 15),
          Divider(color: const Color(0xFF2D3548), thickness: 1),
          const SizedBox(height: 15),

          // Previous period total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppString.total.tr()} $periodText',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              Text(
                '${previousTotal.toStringAsFixed(2)} ${AppString.currency.tr()}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Current period total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.currentTotal.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${currentTotal.toStringAsFixed(2)} ${AppString.currency.tr()}',
                style: TextStyle(
                  color: AppColors.primary,
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

  Widget _buildCostItem(
    String label,
    double amount,
    Color color,
    double consumption,
    double rate,
  ) {
    return Column(
      children: [
        Row(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${consumption.toStringAsFixed(1)} ${AppString.unitK.tr()} × ${rate.toStringAsFixed(2)} ${AppString.currency.tr()}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              '${amount.toStringAsFixed(2)} ${AppString.currency.tr()}',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPeakUsageCard(AnalyticsCubit cubit, BuildContext context) {
    var model = cubit.analyticsModel;
    var peakUsage = model?.peakUsage ?? [];

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
                AppString.peakHours.tr(),
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

          if (peakUsage.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  AppString.noData.tr(),
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            )
          else
            ...peakUsage.map(
              (peak) => _buildPeakTimeItem(
                peak.timeRange ?? '',
                peak.level ?? '',
                peak.avgConsumption ?? 0,
                _getPeakColor(peak.level ?? ''),
                context,
              ),
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
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 12),
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
                Text(
                  AppLocalization.isArabic(context)
                      ? level
                      : level.contains('متوسطة')
                      ? "Medium Peak"
                      : level.contains('منخفض')
                      ? "Low Consumption"
                      : "High Peak",
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${kwh.toStringAsFixed(1)} ${AppString.unitK.tr()}',
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

  Widget _buildDeviceConsumptionRanking(AnalyticsCubit cubit) {
    var model = cubit.analyticsModel;
    var rankings = model?.deviceRankings ?? [];

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
            AppString.topConsumingDevices.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          if (rankings.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  AppString.noActiveDevices.tr(),
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            )
          else
            ...rankings.map(
              (device) => _buildDeviceRankItem(
                device.rank ?? 0,
                device.deviceName ?? '',
                _getDeviceIcon(device.deviceType ?? ''),
                device.consumption ?? 0,
                device.percentage ?? 0,
                _getDeviceColor(device.rank ?? 0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceRankItem(
    int rank,
    String name,
    IconData icon,
    double wh,
    double percentage,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 12),
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
                  '${(wh / 1000).toStringAsFixed(3)} ${AppString.unitK.tr()}',
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

  // Widget _buildSavingsSuggestions() {
  //   return Container(
  //     padding: const EdgeInsets.all(25),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           const Color(0xFF8FD63F).withOpacity(0.2),
  //           AppColors.primary.withOpacity(0.1),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(25),
  //       border: Border.all(color: AppColors.primary.withOpacity(0.3)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: AppColors.primary.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Icon(
  //                 Icons.lightbulb_rounded,
  //                 color: AppColors.primary,
  //                 size: 24,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               'توصيات للتوفير',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         _buildSuggestionItem(
  //           'رفع درجة حرارة المكيف إلى 24°',
  //           'يمكنك توفير 85 ${AppString.currency.tr()} شهرياً',
  //           Icons.thermostat_rounded,
  //         ),
  //         const SizedBox(height: 12),
  //         _buildSuggestionItem(
  //           'جدولة سخان الماء لأوقات خارج الذروة',
  //           'يمكنك توفير 62 ${AppString.currency.tr()} شهرياً',
  //           Icons.schedule_rounded,
  //         ),
  //         const SizedBox(height: 12),
  //         _buildSuggestionItem(
  //           'استخدام الإضاءة الذكية مع مستشعرات الحركة',
  //           'يمكنك توفير 28 ${AppString.currency.tr()} شهرياً',
  //           Icons.sensors_rounded,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildSuggestionItem(String title, String savings, IconData icon) {
  //   return Container(
  //     padding: const EdgeInsets.all(15),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1E2538),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: AppColors.primary.withOpacity(0.15),
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Icon(icon, color: AppColors.primary, size: 20),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 savings,
  //                 style: TextStyle(
  //                   color: AppColors.primary,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAIPredictionCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(25),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           const Color(0xFF6C63FF).withOpacity(0.9),
  //           const Color(0xFF5B54E8).withOpacity(0.8),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(25),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF6C63FF).withOpacity(0.3),
  //           blurRadius: 25,
  //           offset: const Offset(0, 12),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: const Icon(
  //                 Icons.auto_awesome_rounded,
  //                 color: Colors.white,
  //                 size: 24,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     'توقعات الذكاء الاصطناعي',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     'تحليل بناءً على آخر 90 يوم',
  //                     style: TextStyle(
  //                       color: Colors.white.withOpacity(0.8),
  //                       fontSize: 12,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 10,
  //                 vertical: 5,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: AppColors.primary,
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: const Text(
  //                 '94% دقة',
  //                 style: TextStyle(
  //                   color: Color(0xFF0A0E1A),
  //                   fontSize: 11,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Container(
  //           padding: const EdgeInsets.all(18),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.15),
  //             borderRadius: BorderRadius.circular(18),
  //             border: Border.all(color: Colors.white.withOpacity(0.2)),
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'استهلاك متوقع للشهر القادم',
  //                           style: TextStyle(
  //                             color: Colors.white.withOpacity(0.9),
  //                             fontSize: 13,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.end,
  //                           children: [
  //                             const Text(
  //                               '695',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 32,
  //                                 fontWeight: FontWeight.bold,
  //                                 height: 1,
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 5),
  //                               child: Text(
  //                                 ' ${AppString.unitK.tr()}',
  //                                 style: TextStyle(
  //                                   color: Colors.white.withOpacity(0.8),
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFFFF6B6B).withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: const Column(
  //                       children: [
  //                         Icon(
  //                           Icons.trending_up,
  //                           color: Color(0xFFFF6B6B),
  //                           size: 24,
  //                         ),
  //                         SizedBox(height: 4),
  //                         Text(
  //                           '+1.2%',
  //                           style: TextStyle(
  //                             color: Color(0xFFFF6B6B),
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 15),
  //               Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
  //               const SizedBox(height: 15),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'التكلفة المتوقعة',
  //                           style: TextStyle(
  //                             color: Colors.white.withOpacity(0.9),
  //                             fontSize: 13,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 6),
  //                         Text(
  //                           '610 ${AppString.currency.tr()}',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 22,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'توفير محتمل',
  //                           style: TextStyle(
  //                             color: Colors.white.withOpacity(0.9),
  //                             fontSize: 13,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 6),
  //                         Text(
  //                           '127 ${AppString.currency.tr()}',
  //                           style: TextStyle(
  //                             color: AppColors.primary,
  //                             fontSize: 22,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 15),
  //         TextButton.icon(
  //           onPressed: () {},
  //           icon: const Icon(Icons.insights, color: Colors.white, size: 18),
  //           label: const Text(
  //             'عرض التفاصيل الكاملة',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           style: TextButton.styleFrom(
  //             backgroundColor: Colors.white.withOpacity(0.15),
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Helper methods
  Color _getPeakColor(String level) {
    if (level.contains('عالية')) {
      return const Color(0xFFFF6B6B);
    } else if (level.contains('متوسطة')) {
      return const Color(0xFFFFB84D);
    } else {
      return const Color(0xFF4ECDC4);
    }
  }

  Color _getDeviceColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.primary;
      case 2:
        return const Color(0xFF4ECDC4);
      case 3:
        return const Color(0xFFFFB84D);
      case 4:
        return const Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'ac':
      case 'air conditioner':
        return Icons.ac_unit_rounded;
      case 'water heater':
        return Icons.water_drop_rounded;
      case 'refrigerator':
      case 'fridge':
        return Icons.kitchen_rounded;
      case 'washing machine':
        return Icons.local_laundry_service_rounded;
      case 'light':
      case 'lighting':
        return Icons.lightbulb_rounded;
      default:
        return Icons.devices_rounded;
    }
  }
}
