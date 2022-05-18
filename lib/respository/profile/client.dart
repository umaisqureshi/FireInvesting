import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

import 'package:MOT/helpers/http_helper.dart';
import 'package:MOT/helpers/variables.dart';
import 'package:MOT/keys/api_keys.dart';

import 'package:MOT/models/profile/profile.dart';
import 'package:MOT/models/profile/stock_chart.dart';

import 'package:MOT/models/profile/stock_profile.dart';
import 'package:MOT/models/profile/stock_quote.dart';

extension GetByKeyIndex on Map {
  elementAt(int index) => this.keys.elementAt(index);
}

extension GetByKeySize on Map {
  take(int length) => this.keys.length >= length
      ? this.keys.take(length).toList()
      : this.keys.toList();
}

class ProfileClient extends FetchClient {
  Future<StockQuote> fetchProfileChanges({String symbol}) async {
    final Uri uri = Uri.https(authority, '/api/v3/quote/$symbol');
    final Response<dynamic> response = await FetchClient().fetchData(uri: uri);

    return StockQuote.fromJson(response.data[0]);
  }

  Future<ProfileModel> fetchStockData({String symbol}) async {
    final Response<dynamic> stockProfile =
    symbol.contains("^")?null:await super.financialModelRequest('/api/v3/company/profile/$symbol');
    final Response<dynamic> stockQuote =
        await super.financialModelRequest('/api/v3/quote/$symbol');
    final Response<dynamic> stockChart = await _fetchChart(symbol: symbol);
    final Response<dynamic> stockChart5Y = await _fetchChart5y(symbol: symbol);
    final Response<dynamic> stockChart1M =
        await _fetchChartByMonth(symbol: symbol, month: 30);
    final Response<dynamic> stockChart3M =
        await _fetchChartByMonth(symbol: symbol, month: 90);
    final Response<dynamic> stockChart6M =
        await _fetchChartByMonth(symbol: symbol, month: 180);

    final Response<dynamic> stockChartByDayList =
        await _fetchChartDaily(symbol: symbol);
    List<StockChart> list = StockChart.toListByDay(stockChartByDayList.data);
    Map<dynamic, List<StockChart>> stockChartByDay =
        groupBy(list, (obj) => obj.date.substring(0, 10));
    var key = stockChartByDay.elementAt(0);
    var keys = stockChartByDay.take(5);
    List<StockChart> stockChartForXDays = [];
    keys.forEach((element) {
      stockChartByDay[element].forEach((stockChart) {
        stockChartForXDays.add(stockChart);
      });
    });
    return ProfileModel(
      stockQuote: StockQuote.fromJson(stockQuote.data[0]),
      stockProfile: stockProfile!=null?StockProfile.fromJson(stockProfile.data['profile']):null,
      stockChart: StockChart.toList(stockChart.data['historical']),
      stockChart1D: stockChartByDay[key].toList(),
      stockChart5D: stockChartForXDays.toList(),
      stockChart5Y: StockChart.toList(stockChart5Y.data['historical']),
      stockChart1M: StockChart.toList(stockChart1M.data['historical']),
      stockChart3M: StockChart.toList(stockChart3M.data['historical']),
      stockChart6M: StockChart.toList(stockChart6M.data['historical']),
    );
  }

  static Future<Response> _fetchChart({String symbol}) async {
    final DateTime date = DateTime.now();
    final Uri uri =
        Uri.https(authority, '/api/v3/historical-price-full/$symbol', {
      'from': '${date.year - 1}-${date.month}-${date.day}',
      'to': '${date.year}-${date.month}-${date.day - 1}',
      'apikey': kFinancialModelingPrepApi
    });
    return await FetchClient().fetchData(uri: uri);
  }

  static Future<Response> _fetchChart5y({String symbol}) async {
    final DateTime date = DateTime.now();
    final Uri uri =
        Uri.https(authority, '/api/v3/historical-price-full/$symbol', {
      'from': '${date.year - 5}-${date.month}-${date.day}',
      'to': '${date.year}-${date.month}-${date.day - 1}',
      'apikey': kFinancialModelingPrepApi
    });

    return await FetchClient().fetchData(uri: uri);
  }

  static Future<Response> _fetchChartByMonth({String symbol, month}) async {
    final DateTime date = DateTime.now();
    final Uri uri = Uri.https(
        authority,
        '/api/v3/historical-price-full/$symbol',
        {'timeseries': '$month', 'apikey': kFinancialModelingPrepApi});

    return await FetchClient().fetchData(uri: uri);
  }

  static Future<Response> _fetchChartDaily({String symbol}) async {
    final Uri uri = Uri.https(
        authority,
        '/api/v3/historical-chart/1min/$symbol',
        {'apikey': kFinancialModelingPrepApi});

    return await FetchClient().fetchData(uri: uri);
  }
}
