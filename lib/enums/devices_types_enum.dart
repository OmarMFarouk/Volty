import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum DeviceTypes {
  ac("Air Conditioner", "مكيف الهواء", Icons.ac_unit),
  tv("Smart TV", "التلفاز الذكي", Icons.tv_rounded),
  light("Light", "الإضاءة", Icons.lightbulb_rounded),
  bedLight("Bed Lamp", "مصباح السرير", Icons.lightbulb_outline_rounded),
  refrigerator("Refrigerator", "الثلاجة", Icons.kitchen_rounded),
  dishwasher("Dishwasher", "غسالة الأطباق", Icons.countertops_rounded),
  microwave("Microwave", "الميكروويف", Icons.microwave_rounded),
  waterHeater("Water Heater", "سخان الماء", Icons.water_drop_rounded),
  washingMachine(
    "Washing Machine",
    "غسالة الملابس",
    Icons.local_laundry_service_rounded,
  ),
  fan("Fan", "مروحة", FontAwesomeIcons.fan),
  heater("Heater", "سخان", Icons.thermostat_rounded),
  airPurifier("Air Purifier", "منقي الهواء", Icons.air_rounded),
  vacuumCleaner(
    "Vacuum Cleaner",
    "مكنسة كهربائية",
    Icons.cleaning_services_rounded,
  ),
  coffeemaker("Coffee Maker", "صانع القهوة", Icons.coffee_rounded),
  oven("Oven", "الفرن", Icons.heat_pump_outlined),
  router("Router", "جهاز التوجيه", Icons.router_rounded),
  speaker("Smart Speaker", "مكبر صوت ذكي", Icons.speaker_rounded),
  camera("Security Camera", "كاميرا أمنية", Icons.videocam_rounded),
  doorLock("Smart Lock", "قفل ذكي", Icons.lock_rounded),
  thermostat("Thermostat", "منظم الحرارة", Icons.device_thermostat_rounded),
  smartPlug("Smart Plug", "مقبس ذكي", Icons.power_rounded),
  garageDoor("Garage Door", "باب الجراج", Icons.garage_rounded),
  curtains("Smart Curtains", "ستائر ذكية", Icons.curtains_rounded),
  dehumidifier("Dehumidifier", "مزيل الرطوبة", Icons.opacity_rounded),
  laptop("Laptop", "حاسوب محمول", Icons.laptop_rounded),
  desktop("Desktop", "حاسوب مكتبي", Icons.computer_rounded),
  printer("Printer", "طابعة", Icons.print_rounded),
  other("Other", "أخرى", Icons.devices_other_rounded);

  final String en;
  final String ar;
  final IconData icon;

  const DeviceTypes(this.en, this.ar, this.icon);

  static DeviceTypes? fromString(String? type) {
    if (type == null) return null;
    try {
      return DeviceTypes.values.firstWhere(
        (e) => e.en.toLowerCase() == type.toLowerCase(),
        orElse: () => DeviceTypes.other,
      );
    } catch (e) {
      return DeviceTypes.other;
    }
  }

  static IconData getIcon(String? type) {
    return fromString(type)?.icon ?? DeviceTypes.other.icon;
  }

  static String getArabicName(String? type) {
    return fromString(type)?.ar ?? DeviceTypes.other.ar;
  }
}
