import 'package:meta/meta.dart';

class StockOverviewModel {
  final String symbol;
  final String name;
  final double price;
  final double changesPercentage;
  final double change;

  StockOverviewModel(
      {@required this.symbol,
      @required this.name,
      @required this.price,
      @required this.changesPercentage,
      @required this.change});

  factory StockOverviewModel.fromJson(Map<String, dynamic> json) {
    return StockOverviewModel(
      symbol: json['symbol'] ?? null,
      name: json['name'] ?? null,
      price: json['price'] ?? null,
      changesPercentage: json['changesPercentage'] ?? null,
      change: json['change'] ?? null,
    );
  }

  bool isNotEmpty() {
    return this.symbol != null &&
        this.name != null &&
        this.price != null &&
        this.changesPercentage != null &&
        this.change != null;
  }
}
