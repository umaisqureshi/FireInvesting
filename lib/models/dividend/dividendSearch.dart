import 'package:meta/meta.dart';

class DividendSearch {
  final String symbol;
  final int quantity;

  DividendSearch({
    @required this.symbol,
  @required this.quantity,
  });

  @override
  String toString() {
    return 'DividendSearch{symbol: $symbol, quantity: $quantity}';
  }

  static List<DividendSearch> convertToList(List<dynamic> items) {
    return items
        .map((item) => DividendSearch.fromJson(item))
        .toList();
  }

  factory DividendSearch.fromJson( Map<String, dynamic> json) {
    return DividendSearch(symbol: json['symbol'], quantity: json['quantity']);
  }

}