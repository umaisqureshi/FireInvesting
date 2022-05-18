part of 'dividend_bloc.dart';

@immutable
abstract class DividendState {}

class DividendInitial extends DividendState {}

class DividendError extends DividendState {

  final String message;

  DividendError({
    @required this.message
  });
}

class DividendLoading extends DividendState {}

class UpdateDividend extends DividendState {}

class LoadedFromLocal extends DividendState {
  final List<DividendSP> sp;
  LoadedFromLocal({
    @required this.sp
  });
}


class DividendLoaded extends DividendState {
  final DividendSP dividendSP;

  DividendLoaded({this.dividendSP});
}

class YieldLoaded extends DividendState {
  final DividendYieldModel dividendYieldModel;

  YieldLoaded({this.dividendYieldModel});
}
