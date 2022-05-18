import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class StockChart {
  final String date;
  final double close;
  final String label;

  StockChart({
    @required this.date,
    @required this.close,
    @required this.label,
  });

  static List<StockChart> toList(List<dynamic> items) {
    return items.map((item) => StockChart.fromJson(item)).toList();
  }

  static List<StockChart> toListByDay(List<dynamic> items) {
    return items.map((item) => StockChart.fromJsonByDay(item)).toList();
  }

  factory StockChart.fromJson(Map<dynamic, dynamic> json) {
    return StockChart(
      date: json['date'],
      close: json['close'],
      label: json['label'],
    );
  }

  factory StockChart.fromJsonByDay(Map<dynamic, dynamic> json) {
    return StockChart(
      date: json['date'],
      close: json['close'],
      label: _convertDate(json['date']),
    );
  }
}

_convertDate(date) {
  var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  var inputDate = inputFormat.parse(date);
  var outputFormat = DateFormat('MMMM dd, yy');
  return outputFormat.format(inputDate);
}
