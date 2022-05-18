class Dividend {
  final String companyName;
  final double dividendYield;
  final double close;
  final double total;
  final int quantity;
  final String symbol;


  Dividend({
    this.companyName,
    this.dividendYield,
    this.close,
    this.total,
    this.quantity,
    this.symbol
  });

  factory Dividend.fromJsonState(Map<String, dynamic> json) {
    return Dividend(
      companyName: json['companyName'],
      dividendYield: double.parse(json['dividendYield'].toString()),


    );
  }

  factory Dividend.fromJsonPrevious(Map<String, dynamic> json) {
    return Dividend(
      close: json['close'],
    );
  }

  factory Dividend.total(total, qty, symbol) {
    return Dividend(
      total: total,
      quantity: qty,
      symbol: symbol
    );
  }

  @override
  String toString() {
    return 'Dividend{companyName: ${companyName??""}, dividendYield: ${dividendYield??""}, close: ${close??""}, total: ${total??""}';
  }
}
