import 'dart:convert';

StockHistoricalFullPrice stockHistoricalFullPriceFromJson(String str) =>
    StockHistoricalFullPrice.fromJson(json.decode(str));

class StockHistoricalFullPrice {
  List<HistoricalStockList> historicalStockList;

  StockHistoricalFullPrice({
    this.historicalStockList,
  });

  factory StockHistoricalFullPrice.fromJson(Map<String, dynamic> json) =>
      StockHistoricalFullPrice(
        historicalStockList: List<HistoricalStockList>.from(
            json["historicalStockList"]
                .map((x) => HistoricalStockList.fromJson(x))),
      );
}

class HistoricalStockList {
  HistoricalStockList({
    this.symbol,
    this.historical,
  });

  String symbol;
  List<Historical> historical;

  factory HistoricalStockList.fromJson(Map<String, dynamic> json) =>
      HistoricalStockList(
        symbol: json["symbol"],
        historical: List<Historical>.from(
            json["historical"].map((x) => Historical.fromJson(x))),
      );
}

class Historical {
  Historical({
    this.date,
    this.close,
  });

  DateTime date;
  double close;

  factory Historical.fromJson(Map<String, dynamic> json) => Historical(
        date: DateTime.parse(json["date"]),
        close: json["close"].toDouble(),
      );
}
