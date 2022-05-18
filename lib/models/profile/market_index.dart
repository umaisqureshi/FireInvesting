import 'dart:convert';

List<MarketIndexModel> marketIndexModelFromJson(List<dynamic> items) => items.map((item) => MarketIndexModel.fromJson(item)).toList();

class MarketIndexModel {
  MarketIndexModel({
    this.symbol,
    this.name,
    this.price,
    this.changesPercentage,
    this.change,
    this.dayLow,
    this.dayHigh,
    this.yearHigh,
    this.yearLow,
    this.marketCap,
    this.priceAvg50,
    this.priceAvg200,
    this.volume,
    this.avgVolume,
    this.exchange,
    this.open,
    this.previousClose,
    this.eps,
    this.pe,
    this.earningsAnnouncement,
    this.sharesOutstanding,
    this.timestamp,
  });

  String symbol;
  String name;
  double price;
  double changesPercentage;
  double change;
  double dayLow;
  double dayHigh;
  double yearHigh;
  double yearLow;
  dynamic marketCap;
  double priceAvg50;
  double priceAvg200;
  int volume;
  int avgVolume;
  String exchange;
  double open;
  double previousClose;
  dynamic eps;
  dynamic pe;
  dynamic earningsAnnouncement;
  dynamic sharesOutstanding;
  int timestamp;

  factory MarketIndexModel.fromJson(Map<String, dynamic> json) => MarketIndexModel(
    symbol: json["symbol"],
    name: json["name"],
    price: json["price"].toDouble(),
    changesPercentage: json["changesPercentage"].toDouble(),
    change: json["change"].toDouble(),
    dayLow: json["dayLow"].toDouble(),
    dayHigh: json["dayHigh"].toDouble(),
    yearHigh: json["yearHigh"].toDouble(),
    yearLow: json["yearLow"].toDouble(),
    marketCap: json["marketCap"],
    priceAvg50: json["priceAvg50"].toDouble(),
    priceAvg200: json["priceAvg200"].toDouble(),
    volume: json["volume"],
    avgVolume: json["avgVolume"],
    exchange: json["exchange"],
    open: json["open"].toDouble(),
    previousClose: json["previousClose"].toDouble(),
    eps: json["eps"],
    pe: json["pe"],
    earningsAnnouncement: json["earningsAnnouncement"],
    sharesOutstanding: json["sharesOutstanding"],
    timestamp: json["timestamp"],
  );
}
