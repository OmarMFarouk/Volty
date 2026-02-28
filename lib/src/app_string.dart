// ══════════════════════════════════════════════════════════════════════════════
// app_string.dart
//
// Single source of truth for every localisation key in the app.
// Keys are grouped by feature. The constant value == the JSON key.
// ══════════════════════════════════════════════════════════════════════════════

import '../models/ai_model.dart';

class AppString {
  // ── App ──────────────────────────────────────────────────────────────────
  static const String appTitle = 'app_title';
  static const String appShortDesc = 'app_short_desc';

  // ── Onboarding ───────────────────────────────────────────────────────────
  static const String onboardingTitle1 = 'onboarding_title_1';
  static const String onboardingTitle2 = 'onboarding_title_2';
  static const String onboardingTitle3 = 'onboarding_title_3';
  static const String onboardingDesc1 = 'onboarding_desc_1';
  static const String onboardingDesc2 = 'onboarding_desc_2';
  static const String onboardingDesc3 = 'onboarding_desc_3';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String welcomeMsg = 'welcome_msg';
  static const String enter = 'enter';
  static const String welcomeNote1 = 'welcome_note_1';
  static const String welcomeNote2 = 'welcome_note_2';
  static const String welcomeNote3 = 'welcome_note_3';
  static const String loginWelcome1 = 'login_welcome_1';
  static const String loginWelcome2 = 'login_welcome_2';
  static const String loginSignupMsg = 'login_signup_msg';
  static const String signupWelcome1 = 'signup_welcome_1';
  static const String signupWelcome2 = 'signup_welcome_2';
  static const String signupLoginMsg = 'signup_login_msg';
  static const String signup = 'signup';
  static const String login = 'login';
  static const String houseStepTitle = 'house_step_title';
  static const String houseStepMsg = 'house_step_msg';
  static const String houseStepInfo = 'house_step_info';
  static const String userStepTitle = 'user_step_title';
  static const String userStepMsg = 'user_step_msg';
  static const String userStepInfo = 'user_step_info';
  static const String forgot = 'forgot';
  static const String forgotMsg = 'forgot_msg';
  static const String reset = 'reset';
  static const String rememberMe = 'remember_me';

  // ── Form ─────────────────────────────────────────────────────────────────
  static const String basicInfo = 'basic_info';
  static const String contactInfo = 'contact_info';
  static const String securitySettings = 'security_settings';
  static const String houseName = 'house_name';
  static const String ownerName = 'owner_name';
  static const String phone = 'phone';
  static const String country = 'country';
  static const String city = 'city';
  static const String address = 'address';
  static const String confirmPassword = 'confirm_password';
  static const String createAccount = 'create_account';
  static const String verifyDataMsg = 'verify_data_msg';
  static const String termsAgreementMsg = 'terms_agreement_msg';
  static const String invalidEmail = 'invalid_email';
  static const String invalidPhone = 'invalid_phone';
  static const String passwordTitle = 'password_title';
  static const String passwordInfo = 'password_info';
  static const String passwordNoLetter = 'password_no_letter';
  static const String passwordMismatch = 'password_mismatch';
  static const String passwordStrength = 'password_strength';
  static const String passwordLengthCheck = 'pw_length_check';
  static const String passwordDigitsCheck = 'pw_number_check';
  static const String passwordConfirmCheck = 'pw_confirm_check';
  static const String passwordUpperCheck = 'pw_upper_check';
  static const String passwordLowerCheck = 'pw_lower_check';

  // ── Input fields ─────────────────────────────────────────────────────────
  static const String email = 'email';
  static const String password = 'password';
  static const String name = 'name';

  // ── Home ─────────────────────────────────────────────────────────────────
  static const String home = 'home';
  static const String welcomeBack = 'welcome_back';
  static const String today = 'today';
  static const String create = 'create';
  static const String houseDetails = 'house_details';
  static const String addNewHouse = 'add_new_house';
  static const String switchHouse = 'switch_house';
  static const String myHouses = 'my_houses';
  static const String houses = 'houses';

  // ── Navigation / Settings ────────────────────────────────────────────────
  static const String settings = 'settings';
  static const String terms = 'terms';
  static const String policy = 'policy';
  static const String logout = 'logout';
  static const String notification = 'notification';
  static const String version = 'version';
  static const String recent = 'recent';
  static const String empty = 'empty';

  // ── Generic messages ─────────────────────────────────────────────────────
  static const String fillMsg = 'fill_msg';
  static const String requiredMsg = 'required_msg';
  static const String required = 'required';
  static const String invalidFormat = 'invalid_format';
  static const String sureMsg = 'sure_msg';
  static const String warning = 'warning';
  static const String success = 'success';
  static const String refresh = 'refresh';

  // ── Days ─────────────────────────────────────────────────────────────────
  static const String saturday = 'saturday';
  static const String sunday = 'sunday';
  static const String monday = 'monday';
  static const String tuesday = 'tuesday';
  static const String wednesday = 'wednesday';
  static const String thursday = 'thursday';
  static const String friday = 'friday';
  static const String day = 'day';
  static const String week = 'week';
  static const String month = 'month';
  static const String year = 'year';
  static const String recentPeriod = 'recent_period';

  // ── Actions ──────────────────────────────────────────────────────────────
  static const String next = 'next';
  static const String previous = 'previous';
  static const String skip = 'skip';
  static const String cancel = 'cancel';
  static const String processing = 'processing';
  static const String accept = 'accept';
  static const String reject = 'reject';
  static const String enable = 'enable';
  static const String disable = 'disable';
  static const String delete = 'delete';
  static const String start = 'start';
  static const String okay = 'okay';
  static const String add = 'add';
  static const String moreThan = 'more_than';
  static const String lessThan = 'less_than';

  // ── Network ──────────────────────────────────────────────────────────────
  static const String checkNetwork = 'check_network';

  // ── About ────────────────────────────────────────────────────────────────
  static const String aboutTitle = 'about_title';
  static const String aboutDescription = 'about_description';
  static const String contactUs = 'contact_us';

  // ── Account ──────────────────────────────────────────────────────────────
  static const String changePassword = 'change_password';
  static const String changeEmail = 'change_email';
  static const String newEmail = 'new_email';
  static const String newPassword = 'new_password';
  static const String currentPassword = 'current_password';
  static const String copyright = 'copyright';

  // ── Analytics ────────────────────────────────────────────────────────────
  static const String analytics = 'analytics';
  static const String analyticsTitle = 'analytics_title';
  static const String analyticsSubtitle = 'analytics_subtitle';
  static const String consumptionTotal = 'consumption_total';
  static const String total = 'total';
  static const String currency = 'currency';
  static const String unit = 'unit';
  static const String unitK = 'unit_k';
  static const String currentTotal = 'current_total';
  static const String costBreakdown = 'cost_breakdown';
  static const String peakHours = 'peak_consumption_hours';
  static const String topConsumingDevices = 'top_consuming_devices';
  static const String noData = 'no_data';
  static const String noActiveDevices = 'no_active_devices';

  // ── Devices ──────────────────────────────────────────────────────────────
  static const String devicesTitle = 'devices_title';
  static const String devicesSubtitle = 'devices_subtitle';
  static const String rooms = 'rooms';
  static const String roomsEmpty = 'rooms_empty';
  static const String devicesEmpty = 'devices_empty';
  static const String addRoom = 'add_room';
  static const String deleteRoom = 'delete_room';
  static const String editRoom = 'edit_room';
  static const String roomName = 'room_name';
  static const String device = 'device';
  static const String addDevice = 'add_device';
  static const String removeDevice = 'remove_device';
  static const String editDevice = 'edit_device';
  static const String deviceType = 'device_type';
  static const String deviceName = 'device_name';
  static const String powerConsumption = 'power_consumption';
  static const String liveConsumption = 'live_consumption';
  static const String continuousUpdate = 'continuous_update';
  static const String peak = 'peak';
  static const String out = 'out';
  static const String realTimeMeter = 'real_time_meter';
  static const String active = 'active';
  static const String fromMax = 'from_max';
  static const String activeDevices = 'active_devices';
  static const String peakPeriod = 'peak_period';
  static const String showAll = 'show_all';
  static const String weeklyConsumption = 'weekly_consumption';

  // ── Profile ──────────────────────────────────────────────────────────────
  static const String account = 'account';
  static const String verifiedAccount = 'verified_account';
  static const String daysWithUs = 'days_with_us';
  static const String co2Savings = 'co2_savings';
  static const String ton = 'ton';
  static const String kilo = 'kilo';
  static const String profile = 'profile';
  static const String notifications = 'notifications';
  static const String smartReminders = 'smart_reminders';
  static const String language = 'language';
  static const String helpSupport = 'help_support';
  static const String helpCenter = 'help_center';
  static const String rateUs = 'rate_us';
  static const String shareApp = 'share_app';
  static const String about = 'about';

  // ── Help Center ──────────────────────────────────────────────────────────
  static const String faq = 'faq';
  static const String faqTitle = 'faq_title';
  static const String aboutUs = 'about_us';
  static const String aboutUsTitle = 'about_us_title';
  static const String privacyPolicy = 'privacy_policy';
  static const String privacyPolicySubtitle = 'privacy_policy_subtitle';
  static const String deleteAccount = 'delete_account';
  static const String deleteAccountSubtitle = 'delete_account_subtitle';
  static const String termsOfService = 'terms_of_service';
  static const String termsOfServiceSubtitle = 'terms_of_service_subtitle';
  static const String website = 'website';
  static const String support = 'support';
  static const String support24 = 'support_24_7';
  static const String comingSoon = 'coming_soon';
  static const String learnMoreAbout = 'learn_more_about';

  // ── About Us ─────────────────────────────────────────────────────────────
  static const String aboutVoltyTitle = 'about_volty_title';
  static const String aboutVoltySubtitle = 'about_volty_subtitle';
  static const String aboutVoltyDesc = 'about_volty_desc';
  static const String keyFeatures = 'key_features';
  static const String developedBy = 'developed_by';
  static const String companyDescription = 'company_description';
  static const String location = 'location';
  static const String locationValue = 'location_value';
  static const String egyptianHomes = 'egyptian_homes';
  static const String avgSavings = 'avg_savings';
  static const String monitoring247 = 'monitoring_24_7';
  static const String realtimeMonitoring = 'realtime_monitoring';
  static const String smartDeviceControl = 'smart_device_control';
  static const String detailedAnalytics = 'detailed_analytics';
  static const String egyptianTierCalc = 'egyptian_tier_calc';
  static const String aiRecommendations = 'ai_recommendations';
  static const String solarIntegration = 'solar_integration';
  static const String smartScheduling = 'smart_scheduling';
  static const String instantAlerts = 'instant_alerts';

  // ── FAQ ──────────────────────────────────────────────────────────────────
  static const String faqQ1 = 'faq_q1';
  static const String faqA1 = 'faq_a1';
  static const String faqQ2 = 'faq_q2';
  static const String faqA2 = 'faq_a2';
  static const String faqQ3 = 'faq_q3';
  static const String faqA3 = 'faq_a3';
  static const String faqQ4 = 'faq_q4';
  static const String faqA4 = 'faq_a4';
  static const String faqQ5 = 'faq_q5';
  static const String faqA5 = 'faq_a5';
  static const String faqQ6 = 'faq_q6';
  static const String faqA6 = 'faq_a6';
  static const String faqQ7 = 'faq_q7';
  static const String faqA7 = 'faq_a7';
  static const String faqQ8 = 'faq_q8';
  static const String faqA8 = 'faq_a8';
  static const String faqQ9 = 'faq_q9';
  static const String faqA9 = 'faq_a9';
  static const String faqQ10 = 'faq_q10';
  static const String faqA10 = 'faq_a10';
  static const String faqQ11 = 'faq_q11';
  static const String faqA11 = 'faq_a11';
  static const String faqQ12 = 'faq_q12';
  static const String faqA12 = 'faq_a12';

  // ══════════════════════════════════════════════════════════════════════════
  // AI SCREEN — UI labels
  // ══════════════════════════════════════════════════════════════════════════

  static const String aiCenter = 'ai_center';
  static const String aiSubtitle = 'ai_subtitle';
  static const String aiAnalyzing = 'ai_analyzing';
  static const String aiLocalModels = 'ai_local_models';
  static const String quickInsights = 'quick_insights';
  static const String vsLastMonth = 'vs_last_month';
  static const String bestUsageHours = 'best_usage_hours';
  static const String topDeviceLabel = 'top_device_label';
  static const String carbonFootprint = 'carbon_footprint';
  static const String noDeviceDetected =
      'no_device_detected'; // "None detected"
  static const String trendUp = 'trend_up'; // "Up {n}%"
  static const String trendDown = 'trend_down'; // "Down {n}%"
  static const String peakHoursRange = 'peak_hours_range'; // "22:00 – 06:00"
  static const String kgCo2 = 'kg_co2'; // "{n} kg CO₂"
  static const String basedOn90d = 'based_on_90d';
  static const String accuracyPct = 'accuracy_pct'; // "{n}% accuracy"
  static const String warningTier = 'warning_tier';
  static const String onTrack = 'on_track';
  static const String projectedKwh = 'projected_kwh';
  static const String projectedBill = 'projected_bill';
  static const String potentialSavings = 'potential_savings';
  static const String savingPlan = 'saving_plan';
  static const String viewDetails = 'view_details';
  static const String kwh = 'kwh';
  static const String egp = 'egp';
  static const String tierAnalysis = 'tier_analysis';
  static const String tierSafe = 'tier_safe';
  static const String tierDanger = 'tier_danger';
  static const String currentTier = 'current_tier'; // "Current tier {n}"
  static const String daysLeft = 'days_left';
  static const String projectedLabel =
      'projected_label'; // "Projected: {n} kWh"
  static const String exceedsBy = 'exceeds_by'; // "Exceeds by {n} kWh!"
  static const String remainingKwh = 'remaining_kwh'; // "{n} kWh remaining"
  static const String tierTip = 'tier_tip';
  static const String smartSchedule = 'smart_schedule';
  static const String smartScheduleSub = 'smart_schedule_sub';
  static const String scheduleReasonPeak =
      'schedule_reason_peak'; // "Running during peak hours"
  static const String noPeakDevices = 'no_peak_devices';
  static const String applySchedule = 'apply_schedule';
  static const String saveEgp = 'save_egp'; // "Save {n} EGP"
  static const String anomalyDetection = 'anomaly_detection';
  static const String anomalySub = 'anomaly_sub';
  static const String noAnomalies = 'no_anomalies';
  static const String detectedAt = 'detected_at'; // "Detected on {date}"
  static const String severityHigh = 'severity_high';
  static const String severityMedium = 'severity_medium';
  static const String severityLow = 'severity_low';
  static const String costForecast = 'cost_forecast';
  static const String costForecastSub = 'cost_forecast_sub';
  static const String noForecastData = 'no_forecast_data';
  static const String summerWarning = 'summer_warning';
  static const String behaviorProfile = 'behavior_profile';
  static const String behaviorSub = 'behavior_sub';
  static const String usagePattern = 'usage_pattern';
  static const String peakDay = 'peak_day';
  static const String efficiencyScore = 'efficiency_score';
  static const String homeRating = 'home_rating';
  static const String achievementClose = 'achievement_close';
  static const String achievementSub = 'achievement_sub';
  static const String aiRecSub = 'ai_rec_sub';
  static const String noRecommendations = 'no_recommendations';
  static const String impactLabel = 'impact_label';

  // ── Month names (used by widget via monthKey helper) ─────────────────────
  static const String monthJan = 'month_jan';
  static const String monthFeb = 'month_feb';
  static const String monthMar = 'month_mar';
  static const String monthApr = 'month_apr';
  static const String monthMay = 'month_may';
  static const String monthJun = 'month_jun';
  static const String monthJul = 'month_jul';
  static const String monthAug = 'month_aug';
  static const String monthSep = 'month_sep';
  static const String monthOct = 'month_oct';
  static const String monthNov = 'month_nov';
  static const String monthDec = 'month_dec';

  /// Returns the AppString key for month number 1–12.
  /// Usage: AppString.monthKey(forecast.monthNumber).tr()
  static String monthKey(int m) {
    const _keys = [
      '',
      monthJan,
      monthFeb,
      monthMar,
      monthApr,
      monthMay,
      monthJun,
      monthJul,
      monthAug,
      monthSep,
      monthOct,
      monthNov,
      monthDec,
    ];
    return _keys[m.clamp(1, 12)];
  }

  // ── Usage patterns (enum → key) ──────────────────────────────────────────
  static const String patternMorning = 'pattern_morning';
  static const String patternAfternoon = 'pattern_afternoon';
  static const String patternEvening = 'pattern_evening';
  static const String patternNight = 'pattern_night';

  /// Returns the AppString key for a [UsagePattern] enum value.
  /// Usage: AppString.patternKey(profile.usagePattern).tr()
  static String patternKey(UsagePattern p) {
    switch (p) {
      case UsagePattern.morning:
        return patternMorning;
      case UsagePattern.afternoon:
        return patternAfternoon;
      case UsagePattern.evening:
        return patternEvening;
      case UsagePattern.night:
        return patternNight;
    }
  }

  // ── Anomaly title / description keys ─────────────────────────────────────
  // The cubit maps raw inference labels → these keys.
  // Widget calls: anomalyItem.titleKey.tr()
  static const String anomalyNightTitle = 'anomaly_night_title';
  static const String anomalyNightDesc = 'anomaly_night_desc';
  static const String anomalySpikeTitle = 'anomaly_spike_title';
  static const String anomalySpikeDesc = 'anomaly_spike_desc';
  static const String anomalyIdleTitle = 'anomaly_idle_title';
  static const String anomalyIdleDesc = 'anomaly_idle_desc';
  static const String anomalyGenericTitle = 'anomaly_generic_title';
  static const String anomalyGenericDesc = 'anomaly_generic_desc';

  // ── Cubit API messages ───────────────────────────────────────────────────
  static const String aiErrorNetwork =
      'ai_error_network'; // "Check your connection"
  static const String aiErrorGeneric =
      'ai_error_generic'; // "Something went wrong: {error}"
  static const String aiSuccessLoad = 'ai_success_load'; // "Insights loaded"

  // ── Recommendation title / savings keys ──────────────────────────────────
  // titleArgs / savingsArgs are passed as namedArgs to .tr().
  static const String recAcReduceTitle =
      'rec_ac_reduce_title'; // "Reduce AC by {n} kWh"
  static const String recSavingsEgp =
      'rec_savings_egp'; // "Save {n} EGP/month" (shared)
  static const String recAcTempTitle = 'rec_ac_temp_title'; // "Set AC to 24°C"
  static const String recAcTempSavings =
      'rec_ac_temp_savings'; // "Save 85 EGP/month"
  static const String recHeaterTitle =
      'rec_heater_title'; // "Schedule heater after 22:00"
  static const String recHeaterSavings =
      'rec_heater_savings'; // "Save 62 EGP/month"
  static const String recLightingTitle =
      'rec_lighting_title'; // "Smart lighting sensors"
  static const String recLightingSavings =
      'rec_lighting_savings'; // "Save 28 EGP/month"
  static const String recStandbyTitle =
      'rec_standby_title'; // "Unplug standby devices"
  static const String recStandbySavings =
      'rec_standby_savings'; // "Save 15 EGP/month"

  // ── Misc ─────────────────────────────────────────────────────────────────
  static const String and = 'and';
}
