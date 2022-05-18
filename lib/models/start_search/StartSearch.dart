import 'package:meta/meta.dart';

class StartStockSearch {
  final String symbol;
  final String name;
  final double price;
  final String exchange;

  StartStockSearch({
    @required this.symbol,
    @required this.name,
    @required this.price,
    @required this.exchange,
  });

  static List<StartStockSearch> convertToList(List<dynamic> items) {
    return items.map((item) => StartStockSearch.fromJson(item)).toList();
  }

  factory StartStockSearch.fromJson(Map<String, dynamic> json) {
    return StartStockSearch(
        symbol: json['symbol'],
        name: json['name'],
        price: json['price'],
        exchange: json['exchange']);
  }
}
