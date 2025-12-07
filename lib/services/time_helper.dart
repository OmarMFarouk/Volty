import 'package:intl/intl.dart';

class TimeParser {
  final String date;
  TimeParser({required this.date});
  String get arabicFormat {
    final target = DateTime.tryParse(date.split(' ')[0]);
    if (target == null) {
      return "غير محدد";
    } // الثلاثاء 7 يونيو 2025
    final formatter = DateFormat('EEEE d MMMM y', 'ar_EG');
    return formatter.format(target);
  }

  String get longFormat {
    try {
      var parsedDate = DateTime.parse(date);
      String year = parsedDate.year.toString();
      String month = parsedDate.month.toString();
      String day = parsedDate.day.toString();
      String tod = parsedDate.hour > 12 ? "م" : "ص";
      String hour =
          (parsedDate.hour > 12 ? parsedDate.hour - 12 : parsedDate.hour)
              .toString()
              .padLeft(2, "0");
      String minute = (parsedDate.minute).toString().padLeft(2, "0");
      return "$year/$month/$day $hour:$minute $tod"
          .split(" ")
          .reversed
          .join(' ');
    } catch (e) {
      return "غير محدد";
    }
  }

  String get backEndFormat {
    try {
      var parsedDate = DateTime.parse(date);
      String year = parsedDate.year.toString();
      String month = parsedDate.month.toString();
      String day = parsedDate.day.toString();
      String hour = DateTime.now().hour.toString().padLeft(2, "0");
      String min = DateTime.now().minute.toString().padLeft(2, "0");
      String sec = DateTime.now().second.toString().padLeft(2, "0");
      String combined = "$hour:$min:$sec $year-$month-$day";
      return combined;
    } catch (e) {
      return "غير محدد";
    }
  }

  String get calendarFormat {
    try {
      var parsedDate = DateTime.parse(date);
      String year = parsedDate.year.toString();
      String month = parsedDate.month.toString();
      String day = parsedDate.day.toString();
      return "$year/$month/$day";
    } catch (e) {
      return "غير محدد";
    }
  }
}
