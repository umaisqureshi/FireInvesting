import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:MOT/models/start_search/StartSearch.dart';
import 'package:MOT/respository/start_search/start_search_client.dart';
part 'start_search_event.dart';
part 'start_search_state.dart';

class StartSearchBloc extends Bloc<StartSearchEvent, StartSearchState> {

  final _client = StartSearchClient();

  @override
  StartSearchState get initialState => StartSearchInitial();

  @override
  Stream<StartSearchState> mapEventToState(StartSearchEvent event) async* {

    if (event is FilterSearchResults) {
      yield StartSearchLoading();
      yield* _filterSavedSearches(symbol: event.symbol);
    }

     if (event is FetchStartSearchResults) {
      yield StartSearchLoading();
      final hasConnection = await DataConnectionChecker().hasConnection;
      if (hasConnection) {
      yield* _fetchSearchResults();
      } else {
        yield StartSearchResultsLoadingError(message: 'No internet connection');
      }
    }

    if (event is FetchSearchFromCacheResults) {
      yield StartSearchLoading();
      yield* _fetchSearchFromCache();
    }
  }


  Stream<StartSearchState> _filterSavedSearches({String symbol}) async* {

    yield StartSearchLoading();
    final data = this._client.filter(symbol: symbol);
    yield data.isEmpty
        ? StartSearchResultsLoadingError(message: 'No recent searches')
        : FilterStartSearchData(data: data);
  }

  Stream<StartSearchState> _fetchSearchFromCache() async* {

    yield StartSearchLoading();
    final data = await this._client.fetchCache();
    yield data.isEmpty
    ? StartSearchResultsLoadingError(message: 'No recent searches')
    : FetchFromCache(data: data);

  }

  Stream<StartSearchState> _fetchSearchResults() async* {
    try {
      final data = await this._client.searchStock();
      yield data.isEmpty
      ? StartSearchResultsLoadingError(message: 'No results were found')
      : FetchStartSearchData(data: data);
    } catch (e) {
      yield StartSearchResultsLoadingError(message: 'There was an error loading');
    }
  }


}