part of 'portfolio_bloc.dart';

@immutable
abstract class PortfolioState {}

class PortfolioInitial extends PortfolioState {}

class PortfolioError extends PortfolioState {

  final String message;

  PortfolioError({
    @required this.message
  });
}

/*class PortfolioStockEmpty extends PortfolioState {

  final List<MarketIndexModel> indexes;

  PortfolioStockEmpty({
    @required this.indexes,
  });
}*/

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {

  final MarketMoversModelData active;
  final MarketMoversModelData gainer;
  final MarketMoversModelData looser;
  final List<MarketIndexModel> indexes;
  final List<StockOverviewModel> stocks;

  PortfolioLoaded({
    @required this.active,
    @required this.gainer,
    @required this.looser,
    @required this.indexes,
    @required this.stocks
  });
}
