part of 'start_search_bloc.dart';

@immutable
abstract class StartSearchEvent {}

class SearchNoConnection extends StartSearchEvent {}

class FilterSearchResults extends StartSearchEvent {
  final String symbol;

  FilterSearchResults({
    @required this.symbol
  });
}

class FetchStartSearchResults extends StartSearchEvent {}

class FetchSearchFromCacheResults extends StartSearchEvent {}
