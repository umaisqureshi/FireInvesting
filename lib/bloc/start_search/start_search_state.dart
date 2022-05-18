part of 'start_search_bloc.dart';

@immutable
abstract class StartSearchState {}

class StartSearchInitial extends StartSearchState {}

class StartSearchLoading extends StartSearchState {}

class FetchStartSearchData extends StartSearchState {

  final List<StartStockSearch> data;

  FetchStartSearchData({
    @required this.data,
  });
}

class FilterStartSearchData extends StartSearchState {

  final List<StartStockSearch> data;

  FilterStartSearchData({
    @required this.data,
  });
}

class FetchFromCache extends StartSearchState {

  final List<StartStockSearch> data;

  FetchFromCache({
    @required this.data,
  });
}

class StartSearchResultsLoadingError extends StartSearchState {
  final String  message;

  StartSearchResultsLoadingError({
    @required this.message
  });
}
