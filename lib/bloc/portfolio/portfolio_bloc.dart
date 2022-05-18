import 'dart:async';

import 'package:MOT/models/data_overview.dart';
import 'package:MOT/models/markets/market_active/market_active_model.dart';
import 'package:MOT/models/profile/market_index.dart';
import 'package:MOT/models/storage/storage.dart';
import 'package:MOT/respository/dividend/client.dart';
import 'package:MOT/respository/market/market_client.dart';
import 'package:MOT/respository/portfolio/client.dart';
import 'package:MOT/respository/portfolio/storage_client.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  
  final _databaseRepository = PortfolioStorageClient();
  final _repository = PortfolioClient();
  final _market = MarketClient();

  @override
  PortfolioState get initialState => PortfolioInitial();

  @override
  Stream<PortfolioState> mapEventToState(PortfolioEvent event) async* {

    if (event is FetchPortfolioData) {
      yield PortfolioLoading();
      yield* _loadContent();
    }

    if (event is SaveProfile) {
      yield PortfolioLoading();
      await this._databaseRepository.save(storageModel: event.storageModel);
      yield* _loadContent();
    }

    if (event is DeleteProfile) {
      yield PortfolioLoading();
      await this._databaseRepository.delete(symbol: event.symbol);
      yield* _loadContent();
    }
  }

  Stream<PortfolioState> _loadContent() async* {

    try {
      final symbolsStored = await _databaseRepository.fetch();
      final indexes = await _repository.fetchIndexes();
      final activeMarket = await _market.fetchMarketActive();
      final gainerMarket = await _market.fetchMarketGainers();
      final looserMarket = await _market.fetchMarketLosers();

       final stocks =   symbolsStored.isNotEmpty?await Future
        .wait(symbolsStored
        .map((symbol) async => await _repository.fetchStocks(symbol: symbol.symbol))):null;

        yield PortfolioLoaded(
          active: activeMarket,
          gainer: gainerMarket,
          looser: looserMarket,
          indexes: indexes,
          stocks: stocks
        );


    
    } catch (e) {
      yield PortfolioError(message: e.toString());
    }
  }
}
