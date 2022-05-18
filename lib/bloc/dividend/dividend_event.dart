part of 'dividend_bloc.dart';

@immutable
abstract class DividendEvent {}

class FetchDividendData extends DividendEvent {
  final String symbol;
  final int quantity;

  FetchDividendData({@required this.symbol, @required this.quantity});
}

class InitDividend extends DividendEvent {}

class SaveDividendSymbol extends DividendEvent {
  final String symbol;
  final int quantity;

  SaveDividendSymbol({@required this.symbol, this.quantity});
}

class FetchDividendYield extends DividendEvent {
  final double dividendPerShare;
  final double costPerShare;
  final int noOfShares;
  final double taxPercent;

  FetchDividendYield({
    @required this.dividendPerShare,
    @required this.costPerShare,
    @required this.noOfShares,
    @required this.taxPercent,
  });
}

class FetchFromLocal extends DividendEvent {}
