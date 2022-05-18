import 'dart:async';
import 'package:MOT/models/dividend/DividendSP.dart';
import 'package:MOT/models/dividend/dividendSearch.dart';
import 'package:MOT/respository/dividend/client.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:MOT/models/dividend/dividendYieldModel.dart';
part 'dividend_event.dart';
part 'dividend_state.dart';

class DividendBloc extends Bloc<DividendEvent, DividendState> {

  final _div = DividendClient();

  @override
  DividendState get initialState => DividendInitial();

  @override
  Stream<DividendState> mapEventToState(DividendEvent event) async* {
    if (event is FetchDividendData) {
      yield DividendLoading();
      yield* _loadContent(event.symbol, event.quantity);
    }
    if(event is SaveDividendSymbol){
      yield* _saveContent(event.symbol, event.quantity);
    }
    if(event is FetchFromLocal){
      yield* _fetchContent();
    }

    if(event is FetchDividendYield){
      yield* _calculateYield(event.dividendPerShare, event.costPerShare, event.taxPercent, event.noOfShares);
    }

  }

  Stream<DividendState> _loadContent(String symbol, int qty) async* {
    try {
      final dividend = await _div.fetchStockData(symbol: symbol, quantity: qty);

        yield DividendLoaded(
          dividendSP: dividend
        );
    } catch (e) {
      yield DividendError(message: e.toString());
    }
  }
  Stream<DividendState> _saveContent(String symbol, int quantity) async* {
    try {
      await _div.save(symbol: symbol, quantity: quantity);
      yield UpdateDividend();

    } catch (e) {
      yield DividendError(message: e.toString());
    }
  }

  Stream<DividendState> _fetchContent() async* {
    try {
      final symbolsStored = await _div.fetch();
      final stocks =   symbolsStored.isNotEmpty?await Future
          .wait(symbolsStored
          .map((symbol) async => await _div.fetchStockData(symbol: symbol.symbol,quantity: symbol.quantity))):null;
      yield LoadedFromLocal(
          sp: stocks
      );
    } catch (e) {
      yield DividendError(message: e.toString());
    }
  }

  Stream<DividendState> _calculateYield(dividendPerShare, costPerShare, taxPercent, noOfShares) async*{
    DividendYieldModel dividendYieldModel =  _div.calculateYield(dividendPerShare, costPerShare, taxPercent, noOfShares);
    yield YieldLoaded(
      dividendYieldModel: dividendYieldModel);
  }
}
