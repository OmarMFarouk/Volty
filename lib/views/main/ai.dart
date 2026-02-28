import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/ai_bloc/cubit.dart';
import '../../blocs/ai_bloc/states.dart';
import '../../models/ai_model.dart';
import '../../src/app_colors.dart';
import '../../src/app_string.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: BlocConsumer<AICubit, AIStates>(
        listener: (ctx, state) {
          if (state is AIError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                // State carries the key; we resolve here in the UI.
                content: Text(state.resolve()),
                backgroundColor: AppColors.danger,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          }
          if (state is AISuccess) {}
        },
        builder: (ctx, state) {
          final cubit = AICubit.get(ctx);
          return SafeArea(
            child: Column(
              children: [
                _TopBar(cubit: cubit, isLoading: state is AILoading),
                if (state is AILoading)
                  const Expanded(child: _LoadingView())
                else
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                      children: [
                        _SectionLabel(AppString.quickInsights.tr()),
                        const SizedBox(height: 10),
                        _QuickInsightsRow(model: cubit.aiModel),
                        const SizedBox(height: 20),
                        _HeroCard(model: cubit.aiModel),
                        const SizedBox(height: 20),
                        _TierCrossingCard(model: cubit.aiModel),
                        const SizedBox(height: 20),
                        _SmartScheduleCard(model: cubit.aiModel),
                        const SizedBox(height: 20),
                        _AnomalyCard(model: cubit.aiModel),
                        const SizedBox(height: 20),
                        CostForecastCard(model: cubit.aiModel),
                        const SizedBox(height: 20),
                        _BehaviorCard(model: cubit.aiModel),
                        const SizedBox(height: 20),
                        _RecommendationsCard(model: cubit.aiModel),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ──────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 3,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
        ),
      ),
    ],
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ──────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final AICubit cubit;
  final bool isLoading;
  const _TopBar({required this.cubit, required this.isLoading});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    decoration: const BoxDecoration(
      color: AppColors.backGround,
      border: Border(bottom: BorderSide(color: AppColors.border)),
    ),
    child: Row(
      children: [
        _IconBtn(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7C5CFC), Color(0xFF06B6D4)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppString.aiCenter.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                AppString.aiSubtitle.tr(),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        _IconBtn(
          icon: Icons.refresh_rounded,
          color: AppColors.primary,
          backGroundColor: AppColors.primary.withOpacity(0.12),
          borderColor: AppColors.primary.withOpacity(0.3),
          isLoading: isLoading,
          onTap: cubit.fetchAIInsights,
        ),
      ],
    ),
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// LOADING
// ──────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.purple.withOpacity(0.2),
                AppColors.purple.withOpacity(0),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.purple,
              strokeWidth: 2,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppString.aiAnalyzing.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppString.aiLocalModels.tr(),
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// QUICK INSIGHTS  –  4 horizontal typed cards
// ══════════════════════════════════════════════════════════════════════════════

class _QuickInsightsRow extends StatelessWidget {
  final AiModel? model;
  const _QuickInsightsRow({this.model});

  @override
  Widget build(BuildContext context) {
    final insights = model?.quickInsights.reversed.toList() ?? _placeholders();
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _QuickCard(insight: insights[i]),
      ),
    );
  }

  List<QuickInsight> _placeholders() => [
    const QuickInsight(type: QuickInsightType.trend),
    const QuickInsight(type: QuickInsightType.peakHours),
    const QuickInsight(type: QuickInsightType.topDevice),
    const QuickInsight(type: QuickInsightType.carbon),
  ];
}

class _QuickCard extends StatelessWidget {
  final QuickInsight insight;
  const _QuickCard({required this.insight});

  // All display logic lives here — cubit stored only typed enum + numbers.
  @override
  Widget build(BuildContext context) {
    final color = _colors();
    final icon = _icon();
    final title = _title();
    final subtitle = _subtitle();

    return Container(
      width: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _colors() {
    switch (insight.type) {
      case QuickInsightType.trend:
        return insight.isPositive ? AppColors.danger : AppColors.success;
      case QuickInsightType.peakHours:
        return AppColors.amber;
      case QuickInsightType.topDevice:
        return AppColors.teal;
      case QuickInsightType.carbon:
        return AppColors.primary;
    }
  }

  IconData _icon() {
    switch (insight.type) {
      case QuickInsightType.trend:
        return insight.isPositive
            ? Icons.trending_up_rounded
            : Icons.trending_down_rounded;
      case QuickInsightType.peakHours:
        return Icons.schedule_rounded;
      case QuickInsightType.topDevice:
        return Icons.ac_unit_rounded;
      case QuickInsightType.carbon:
        return Icons.eco_rounded;
    }
  }

  String _title() {
    switch (insight.type) {
      case QuickInsightType.trend:
        if (insight.numericValue == 0) return '—';
        final key = insight.isPositive
            ? AppString.trendUp
            : AppString.trendDown;
        return key.tr(
          namedArgs: {'n': insight.numericValue.toStringAsFixed(0)},
        );
      case QuickInsightType.peakHours:
        // Business rule: off-peak window is 22:00–06:00, not translatable.
        return AppString.peakHoursRange.tr();
      case QuickInsightType.topDevice:
        return insight.deviceName ?? AppString.noDeviceDetected.tr();
      case QuickInsightType.carbon:
        if (insight.numericValue == 0) return '—';
        return AppString.kgCo2.tr(
          namedArgs: {'n': insight.numericValue.toStringAsFixed(1)},
        );
    }
  }

  String _subtitle() {
    switch (insight.type) {
      case QuickInsightType.trend:
        return AppString.vsLastMonth.tr();
      case QuickInsightType.peakHours:
        return AppString.bestUsageHours.tr();
      case QuickInsightType.topDevice:
        return AppString.topDeviceLabel.tr();
      case QuickInsightType.carbon:
        return AppString.carbonFootprint.tr();
    }
  }
}

class _HeroCard extends StatelessWidget {
  final AiModel? model;
  const _HeroCard({this.model});

  @override
  Widget build(BuildContext context) {
    final tier = model?.tierCrossing;
    final willCross = tier?.willCross ?? false;
    final confidence = tier?.confidence ?? 0.0;
    final projKwh = tier?.projectedMonthEndKwh ?? 0.0;
    final projBill = tier?.projectedBillEgp ?? 0.0;
    final savings = tier?.potentialSavings ?? 0.0;

    final grad = willCross
        ? [const Color(0xFFB91C1C), const Color(0xFF7F1D1D)]
        : [const Color(0xFF1E3A5F), const Color(0xFF164E63)];
    final accent = willCross ? AppColors.danger : AppColors.teal;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: grad,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  willCross
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      willCross
                          ? AppString.warningTier.tr()
                          : AppString.onTrack.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppString.basedOn90d.tr(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  AppString.accuracyPct.tr(
                    namedArgs: {'n': (confidence * 100).toStringAsFixed(0)},
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Stats ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                _HeroStat(
                  label: AppString.projectedKwh.tr(),
                  value: '${projKwh.toStringAsFixed(0)} ${AppString.kwh.tr()}',
                  icon: Icons.bolt_rounded,
                ),
                _vDivider(),
                _HeroStat(
                  label: AppString.projectedBill.tr(),
                  value: '${projBill.toStringAsFixed(0)} ${AppString.egp.tr()}',
                  icon: Icons.receipt_long_rounded,
                ),
                _vDivider(),
                _HeroStat(
                  label: AppString.potentialSavings.tr(),
                  value: '${savings.toStringAsFixed(0)} ${AppString.egp.tr()}',
                  icon: Icons.savings_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Actions ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _HeroBtn(
                  label: AppString.savingPlan.tr(),
                  icon: Icons.lightbulb_outline_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroBtn(
                  label: AppString.viewDetails.tr(),
                  icon: Icons.insights_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, height: 44, color: Colors.white.withOpacity(0.15));
}

class _HeroStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _HeroStat({
    required this.label,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: Colors.white70, size: 17),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 9),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _HeroBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  const _HeroBtn({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 11),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// TIER CROSSING
// ══════════════════════════════════════════════════════════════════════════════

class _TierCrossingCard extends StatelessWidget {
  final AiModel? model;
  const _TierCrossingCard({this.model});

  @override
  Widget build(BuildContext context) {
    final tier = model?.tierCrossing;
    final willCross = tier?.willCross ?? false;
    final projKwh = tier?.projectedMonthEndKwh ?? 0.0;
    final tierMax = tier?.tierMaxKwh ?? 650.0;
    final distNext = tier?.distanceToNextTier ?? 0.0;
    final curTier = tier?.currentTierIdx ?? 1;
    final daysRem = tier?.daysRemaining ?? 0;

    final progressMax = tierMax + max(0, projKwh - tierMax) + 10;
    final progress = (projKwh / progressMax).clamp(0.0, 1.0);
    final barColor = willCross ? AppColors.danger : AppColors.success;

    return _SectionCard(
      icon: Icons.layers_rounded,
      iconColor: barColor,
      title: AppString.tierAnalysis.tr(),
      subtitle: willCross ? AppString.tierDanger.tr() : AppString.tierSafe.tr(),
      subtitleColor: barColor,
      tooltipTitle: AppString.tierAnalysis.tr(),
      tooltipBody: 'tier_tooltip'.tr(), // see JSON below
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.currentTier.tr(namedArgs: {'n': '$curTier'}),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: projKwh.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' / ${tierMax.toStringAsFixed(0)} ${AppString.kwh.tr()}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: barColor.withOpacity(0.25)),
                ),
                child: Column(
                  children: [
                    Text(
                      '$daysRem',
                      style: TextStyle(
                        color: barColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppString.daysLeft.tr(),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ProgressBar(progress: progress, color: barColor),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.projectedLabel.tr(
                  namedArgs: {'n': projKwh.toStringAsFixed(0)},
                ),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              Text(
                willCross
                    ? AppString.exceedsBy.tr(
                        namedArgs: {
                          'n': (projKwh - tierMax).abs().toStringAsFixed(0),
                        },
                      )
                    : AppString.remainingKwh.tr(
                        namedArgs: {'n': distNext.toStringAsFixed(0)},
                      ),
                style: TextStyle(
                  color: barColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (willCross) ...[
            const SizedBox(height: 14),
            _InfoBanner(
              message: AppString.tierTip.tr(),
              color: AppColors.danger,
              icon: Icons.tips_and_updates_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SMART SCHEDULE
// ══════════════════════════════════════════════════════════════════════════════

class _SmartScheduleCard extends StatelessWidget {
  final AiModel? model;
  const _SmartScheduleCard({this.model});

  static const _colors = [
    AppColors.teal,
    AppColors.primary,
    AppColors.amber,
    AppColors.purple,
    AppColors.danger,
  ];
  @override
  Widget build(BuildContext context) {
    final schedule = model?.smartSchedule ?? [];
    return _SectionCard(
      icon: Icons.schedule_rounded,
      iconColor: AppColors.teal,
      title: AppString.smartSchedule.tr(),
      subtitle: AppString.smartScheduleSub.tr(),
      tooltipTitle: AppString.smartSchedule.tr(),
      tooltipBody: 'schedule_tooltip'.tr(),
      child: schedule.isEmpty
          ? _EmptyState(
              AppString.noPeakDevices.tr(),
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
            )
          : Column(
              children: [
                ...schedule.asMap().entries.map(
                  (e) => _ScheduleRow(
                    item: e.value,
                    color: _colors[e.key % _colors.length],
                  ),
                ),
                const SizedBox(height: 6),
                _ApplyBtn(),
              ],
            ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final SmartScheduleItem item;
  final Color color;
  const _ScheduleRow({required this.item, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.backGround,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.22)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_deviceIcon(item.deviceType), color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.deviceName, // user's device name — already correct locale
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: AppColors.textMuted,
                    size: 11,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.recommendedTimeRange, // e.g. "22:00 – 06:00"
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              // Reason is always the same key — resolved here.
              Text(
                AppString.scheduleReasonPeak.tr(),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            AppString.saveEgp.tr(
              namedArgs: {'n': item.savingsEgp.toStringAsFixed(0)},
            ),
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  IconData _deviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'ac':
      case 'airAppColorsonditioner':
        return Icons.ac_unit_rounded;
      case 'water_heater':
        return Icons.water_drop_rounded;
      case 'refrigerator':
        return Icons.kitchen_rounded;
      case 'washing_machine':
        return Icons.local_laundry_service_rounded;
      case 'lighting':
        return Icons.lightbulb_rounded;
      default:
        return Icons.electrical_services_rounded;
    }
  }
}

class _ApplyBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 13),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.teal.withOpacity(0.1),
          AppColors.primary.withOpacity(0.06),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.teal.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.auto_fix_high_rounded,
          color: AppColors.teal,
          size: 17,
        ),
        const SizedBox(width: 8),
        Text(
          AppString.applySchedule.tr(),
          style: const TextStyle(
            color: AppColors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// ANOMALY CARD
// ══════════════════════════════════════════════════════════════════════════════

class _AnomalyCard extends StatelessWidget {
  final AiModel? model;
  const _AnomalyCard({this.model});

  @override
  Widget build(BuildContext context) {
    final anomalies = model?.anomalies ?? [];
    return _SectionCard(
      icon: Icons.radar_rounded,
      iconColor: AppColors.danger,
      title: AppString.anomalyDetection.tr(),
      subtitle: AppString.anomalySub.tr(),
      tooltipTitle: AppString.anomalyDetection.tr(),
      tooltipBody: 'anomaly_tooltip'.tr(),
      child: anomalies.isEmpty
          ? _EmptyState(
              AppString.noAnomalies.tr(),
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
            )
          : Column(children: anomalies.map((a) => _AnomalyRow(a)).toList()),
    );
  }
}

class _AnomalyRow extends StatelessWidget {
  final AnomalyItem a;
  const _AnomalyRow(this.a);

  // Severity → color and localised label resolved entirely in widget.
  Color AppColorsolor() {
    switch (a.severity) {
      case AnomalySeverity.high:
        return AppColors.danger;
      case AnomalySeverity.medium:
        return AppColors.amber;
      case AnomalySeverity.low:
        return AppColors.teal;
    }
  }

  String _severityLabel() {
    switch (a.severity) {
      case AnomalySeverity.high:
        return AppString.severityHigh.tr();
      case AnomalySeverity.medium:
        return AppString.severityMedium.tr();
      case AnomalySeverity.low:
        return AppString.severityLow.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColorsolor();
    // Widget resolves keys from the model — no strings in cubit.
    final title = a.titleKey.tr();
    final description = a.descriptionKey.tr();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.warning_amber_rounded, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _severityLabel(),
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (a.detectedAt.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    AppString.detectedAt.tr(namedArgs: {'date': a.detectedAt}),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CostForecastCard extends StatelessWidget {
  final AiModel? model;
  const CostForecastCard({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    final forecasts = model?.costForecast ?? [];
    return _SectionCard(
      icon: Icons.show_chart_rounded,
      iconColor: AppColors.amber,
      title: AppString.costForecast.tr(),
      subtitle: AppString.costForecastSub.tr(),
      tooltipTitle: AppString.costForecast.tr(),
      tooltipBody: 'forecast_tooltip'.tr(),
      child: forecasts.isEmpty
          ? _EmptyState(AppString.noForecastData.tr(), Icons.bar_chart_rounded)
          : Column(
              children: [
                _BarChart(forecasts: forecasts),
                const SizedBox(height: 16),
                _InfoBanner(
                  message: AppString.summerWarning.tr(),
                  color: AppColors.amber,
                  icon: Icons.wb_sunny_rounded,
                ),
              ],
            ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<MonthForecast> forecasts;
  const _BarChart({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final maxCost = forecasts.map((f) => f.cost).reduce(max);
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: forecasts.map((f) {
          final h = maxCost > 0 ? (f.cost / maxCost) * 110 : 0.0;
          final isMax = f.cost == maxCost;
          final color = isMax ? AppColors.danger : AppColors.amber;
          // Month name resolved from int → key → .tr()
          final label = AppString.monthKey(f.monthNumber).tr();
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    f.cost.toStringAsFixed(0),
                    style: TextStyle(
                      color: isMax ? AppColors.danger : AppColors.textMuted,
                      fontSize: 9,
                      fontWeight: isMax ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color, color.withOpacity(0.5)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isMax ? AppColors.danger : AppColors.textMuted,
                      fontSize: 9,
                      fontWeight: isMax ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BehaviorCard extends StatelessWidget {
  final AiModel? model;
  const _BehaviorCard({this.model});

  @override
  Widget build(BuildContext context) {
    final b = model?.behaviorProfile;
    // All values resolved here from typed enum / key / number.
    final pattern = b != null ? AppString.patternKey(b.usagePattern).tr() : '—';
    final peakDay = b != null ? b.peakDayKey.tr() : '—';
    final score = b?.efficiencyScore ?? 0.0;
    final rating = b?.homeRating ?? '—';

    return _SectionCard(
      icon: Icons.psychology_alt_rounded,
      iconColor: AppColors.purple,
      title: AppString.behaviorProfile.tr(),
      subtitle: AppString.behaviorSub.tr(),
      tooltipTitle: AppString.behaviorProfile.tr(),
      tooltipBody: 'behavior_tooltip'.tr(),
      child: Column(
        spacing: 12,
        children: [
          _StatBox(
            label: AppString.usagePattern.tr(),
            value: pattern,
            color: AppColors.purple,
            icon: Icons.nightlight_round,
          ),
          _StatBox(
            label: AppString.peakDay.tr(),
            value: peakDay,
            color: AppColors.amber,
            icon: Icons.calendar_today_rounded,
          ),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: AppString.efficiencyScore.tr(),
                  value: '${score.toStringAsFixed(0)}%',
                  color: AppColors.success,
                  icon: Icons.eco_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  label: AppString.homeRating.tr(),
                  value: rating, // "A+", "B" etc — universal
                  color: AppColors.primary,
                  icon: Icons.star_rounded,
                ),
              ),
            ],
          ),
          _InfoBanner(
            icon: Icons.emoji_events_rounded,
            color: AppColors.purple,
            title: AppString.achievementClose.tr(),
            message: AppString.achievementSub.tr(),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: color.withOpacity(0.06),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.18)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RecommendationsCard extends StatelessWidget {
  final AiModel? model;
  const _RecommendationsCard({this.model});

  static const _catColors = {
    'tier_protection': AppColors.danger,
    'ac': AppColors.teal,
    'schedule': AppColors.primary,
    'lighting': AppColors.amber,
    'standby': AppColors.purple,
  };
  static const _catIcons = {
    'tier_protection': Icons.shield_rounded,
    'ac': Icons.ac_unit_rounded,
    'schedule': Icons.schedule_rounded,
    'lighting': Icons.lightbulb_rounded,
    'standby': Icons.power_settings_new_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final recs = model?.recommendations ?? [];
    return _SectionCard(
      icon: Icons.lightbulb_rounded,
      iconColor: AppColors.primary,
      title: AppString.aiRecommendations.tr(),
      subtitle: AppString.aiRecSub.tr(),
      tooltipTitle: AppString.aiRecommendations.tr(),
      tooltipBody: 'recs_tooltip'.tr(),
      child: recs.isEmpty
          ? _EmptyState(
              AppString.noRecommendations.tr(),
              Icons.lightbulb_outline_rounded,
            )
          : Column(
              children: recs
                  .map((r) => _RecRow(r, _catColors, _catIcons))
                  .toList(),
            ),
    );
  }
}

class _RecRow extends StatelessWidget {
  final RecommendationItem r;
  final Map<String, Color> catColors;
  final Map<String, IconData> catIcons;
  const _RecRow(this.r, this.catColors, this.catIcons);

  @override
  Widget build(BuildContext context) {
    final color = catColors[r.category] ?? AppColors.primary;
    final icon = catIcons[r.category] ?? Icons.auto_awesome_rounded;

    // Both title and savings resolved via key + args from the model.
    final title = r.titleKey.tr(namedArgs: r.titleArgs);
    final savings = r.savingsKey.tr(namedArgs: r.savingsArgs);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.backGround,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  savings,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (i) => Icon(
                        Icons.bolt,
                        size: 13,
                        color: i < r.impactStars
                            ? AppColors.amber
                            : AppColors.borderLight,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppString.impactLabel.tr(),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final Color? subtitleColor;
  final String? tooltipTitle, tooltipBody;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
    this.tooltipTitle,
    this.tooltipBody,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor ?? AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (tooltipBody != null)
              GestureDetector(
                onTap: () => _showInfo(context),
                child: const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.textMuted,
                    size: 17,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );

  void _showInfo(BuildContext context) => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        tooltipTitle ?? title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        tooltipBody!,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          height: 1.55,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppString.okay.tr(),
            style: const TextStyle(color: AppColors.purple),
          ),
        ),
      ],
    ),
  );
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  const _ProgressBar({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) => Stack(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          height: 10,
          width: c.maxWidth * progress,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.45), blurRadius: 8),
            ],
          ),
        ),
      ],
    ),
  );
}

class _InfoBanner extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  final String? title;
  const _InfoBanner({
    required this.message,
    required this.color,
    required this.icon,
    this.title,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: color.withOpacity(0.07),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
              ],
              Text(
                message,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  final String msg;
  final IconData icon;
  final Color color;
  const _EmptyState(this.msg, this.icon, {this.color = AppColors.teal});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            msg,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final Color backGroundColor;
  final Color? borderColor;
  final bool isLoading;
  const _IconBtn({
    required this.icon,
    this.onTap,
    this.color = Colors.white,
    this.backGroundColor = AppColors.surfaceHigh,
    this.borderColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          : Icon(icon, color: color, size: 18),
    ),
  );
}
