import 'dart:convert';

List<StockHistoricalPrice> stockHistoricalPriceFromJson(String str) =>
    List<StockHistoricalPrice>.from(
        json.decode(str).map((stock) => StockHistoricalPrice.fromJson(stock)));

class StockHistoricalPrice {
  final DateTime date;
  final double open;
  final double low;
  final double high;
  final double close;
  final int volume;

  StockHistoricalPrice({
    this.date,
    this.open,
    this.low,
    this.high,
    this.close,
    this.volume,
  });

  factory StockHistoricalPrice.fromJson(Map<String, dynamic> json) =>
      StockHistoricalPrice(
        date: DateTime.parse(json["date"]),
        open: json["open"].toDouble(),
        low: json["low"].toDouble(),
        high: json["high"].toDouble(),
        close: json["close"].toDouble(),
        volume: json["volume"],
      );
}
