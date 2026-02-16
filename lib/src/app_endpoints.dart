class AppEndPoints {
  static const String website = 'https://volty.barmajha.com';
  static const String privacy = 'https://volty.barmajha.com/legal/privacy';
  static const String terms = 'https://volty.barmajha.com/legal/terms';
  static const String delete = 'https://volty.barmajha.com/legal/delete';
  static const String endPoint = 'https://volty.barmajha.com/backend/public';

  // authentication
  static const String createUser = '$endPoint/auth/register.php';
  static const String loginUser = '$endPoint/auth/login.php';
  static const String tokenChecker = '$endPoint/auth/token_checker.php';
  static const String changePassword = '$endPoint/auth/change_password.php';
  static const String resetPassword = '$endPoint/auth/reset_password.php';

  // App
  static const String showConfigs = '$endPoint/app/configs.php';
  static const String fetchAppPlans = '$endPoint/app/show_plans.php';

  // Dashboard
  static const String showDashboard = '$endPoint/dashboard/show_dashboard.php';

  // Analytics
  static const String showAnalytics = '$endPoint/analytics/show_analytics.php';

  // Households
  static const String manageHousehold =
      '$endPoint/households/manage_household.php';
  static const String switchHousehold =
      '$endPoint/households/switch_household.php';

  // Devices & Rooms
  static const String showDevices = '$endPoint/devices/show_devices.php';
  static const String alterDevice = '$endPoint/devices/alter_device.php';
  static const String manageDevice = '$endPoint/devices/manage_devices.php';
  static const String deleteDevice = '$endPoint/devices/delete_device.php';
  static const String manageRoom = '$endPoint/devices/manage_rooms.php';
  static const String deleteRoom = '$endPoint/devices/delete_room.php';

  // Plans
  static const String showPlans = '$endPoint/plans/show_plans.php';
  static const String addPlan = '$endPoint/plans/add_plan.php';
  static const String editPlan = '$endPoint/plans/edit_plan.php';
  static const String controlPlan = '$endPoint/plans/control_plan.php';
}
