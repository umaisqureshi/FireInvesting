import 'package:dio/dio.dart';
import 'package:MOT/helpers/http_helper.dart';
import 'package:MOT/models/data_overview.dart';
import 'package:MOT/models/profile/market_index.dart';
import 'package:MOT/models/profile/stock_historical_price.dart';

class PortfolioClient extends FetchClient {

  Future<List<MarketIndexModel>> fetchIndexes() async {
    final response = await super.financialModelRequest('/api/v3/quote/^DJI,^GSPC,^IXIC,^RUT,^VIX');
    return marketIndexModelFromJson(response.data);
  }

  Future<List<MarketIndexModel>> fetchActive() async {
    final response = await super.financialModelRequest('/api/v3/actives');
    return marketIndexModelFromJson(response.data);
  }

  Future<List<StockHistoricalPrice>> stockHistoricalPrice(time, symbol) async {
    final Response<dynamic> response = await super.financialHistoricalModelRequest('/api/v3/historical-chart/$time/$symbol');
    return stockHistoricalPriceFromJson(response.data);
  }
  Future<StockOverviewModel> fetchStocks({String symbol}) async {
    final Response<dynamic> response = await super.financialModelRequest('/api/v3/quote/$symbol');
    return StockOverviewModel.fromJson(response.data[0]);
  }
}