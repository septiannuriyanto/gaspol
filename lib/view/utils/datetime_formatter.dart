import 'package:intl/intl.dart';

final String today = DateFormat.yMMMMd('en_US').format(DateTime.now());
final String todayInd = convertToIndDate(DateTime.now());

final String formattedToday = DateFormat('yyyyMMdd').format(DateTime.now());
final String formattedTodayTwoString =
    DateFormat('yyMMdd').format(DateTime.now());
final String formattedMonthDate = DateFormat('MMdd').format(DateTime.now());

String formattedDate(DateTime dt) {
  return DateFormat('yyyyMMdd').format(dt);
}

String convertToIndDateFromyyyyMMdd(String yyyyMMdd) {
  int len = yyyyMMdd.length;
  String day = yyyyMMdd.substring(len - 2, len);
  String year = yyyyMMdd.substring(0, 4);
  String month = yyyyMMdd.substring(4, 6);
  String convertedmonth =
      monthsInYear.entries.firstWhere((element) => element.key == month).value;
  return '$day $convertedmonth $year';
}

String convertToIndDate(DateTime dt) {
  String day = dt.day.toString();
  String year = dt.year.toString();
  String month = dt.month.toString();

  if (day.length == 1) {
    day = "0$day";
  }

  if (month.length == 1) {
    month = "0$month";
  }

  String convertedmonth =
      monthsInYear.entries.firstWhere((element) => element.key == month).value;
  return '$day $convertedmonth $year';
}

String convertToIndDateFromTwoDigit(String yyMMdd) {
  int len = yyMMdd.length;
  String day = yyMMdd.substring(len - 2, len);
  String year = yyMMdd.substring(0, 2);
  String month = yyMMdd.substring(2, 4);
  String convertedmonth =
      monthsInYear.entries.firstWhere((element) => element.key == month).value;
  return '$day $convertedmonth $year';
}

const Map<String, String> monthsInYear = {
  "01": "Januari",
  "02": "Februari",
  "03": "Maret",
  "04": "April",
  "05": "Mei",
  "06": "Juni",
  "07": "Juli",
  "08": "Agustus",
  "09": "September",
  "10": "Oktober",
  "11": "November",
  "12": "Desember"
};

String romanizeMonth(int month) {
  String monthstring = month.toString();

  if (monthstring.length == 0) {
    return '';
  } else if (monthstring.length == 1) {
    monthstring = '0$monthstring';
  } else {
    monthstring = monthstring;
  }

  String convertedMonth = monthsInRoman.entries
      .firstWhere((element) => element.key == monthstring)
      .value;
  return convertedMonth;
}

const Map<String, String> monthsInRoman = {
  "01": "I",
  "02": "II",
  "03": "III",
  "04": "IV",
  "05": "V",
  "06": "VI",
  "07": "VII",
  "08": "VIII",
  "09": "IX",
  "10": "X",
  "11": "XI",
  "12": "XII"
};

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
