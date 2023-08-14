import 'package:intl/intl.dart';

class Utils {
  static String toDate(dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return date;
  }

  static String toTime(dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return time;
  }
}
