import 'package:meta/meta.dart';

import 'package:MOT/models/profile/stock_profile.dart';
import 'package:MOT/models/profile/stock_quote.dart';
import 'package:MOT/models/profile/stock_chart.dart';

class ProfileModel {

  final StockProfile stockProfile;
  final StockQuote stockQuote;
  final List<StockChart> stockChart;
  final List<StockChart> stockChart5Y;
  final List<StockChart> stockChart1M;
  final List<StockChart> stockChart3M;
  final List<StockChart> stockChart6M;
  final List<StockChart> stockChart1D;
  final List<StockChart> stockChart5D;

  ProfileModel({
    @required this.stockProfile,
    @required this.stockQuote,
    @required this.stockChart,
    @required this.stockChart1D,
    @required this.stockChart5D,
    @required this.stockChart5Y,
    @required this.stockChart1M,
    @required this.stockChart3M,
    @required this.stockChart6M
  });
}
