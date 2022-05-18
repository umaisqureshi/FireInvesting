class MarketActiveModel {
  final String symbol;
  final double change;
  final String price;
  final String changesPercentage;
  final String name;

  MarketActiveModel({
    this.symbol,
    this.change,
    this.price,
    this.changesPercentage,
    this.name
  });

  factory MarketActiveModel.fromJson(Map<String, dynamic> json) {
    return MarketActiveModel(
      symbol: json['ticker'],
      change: json['changes'],
      price: json['price'],
      changesPercentage: json['changesPercentage'],
      name: json['companyName'],
    );
  }
}

