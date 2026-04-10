import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static String formatDateTime(DateTime dateTime) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);

  static String formatDate(DateTime dateTime) => DateFormat('dd MMM yyyy').format(dateTime);
}
