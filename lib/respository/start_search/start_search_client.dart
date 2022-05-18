import 'package:dio/dio.dart';
import 'package:MOT/helpers/http_helper.dart';
import 'package:MOT/keys/api_keys.dart';
import 'package:MOT/models/search/search.dart';
import 'package:MOT/models/start_search/StartSearch.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as convert;

class StartSearchClient extends FetchClient {
  List<StartStockSearch> startStockSearchList = [];
  List<StartStockSearch> startStockSearchListTemp = [];
  List<StartStockSearch> startStockSearchListCache = [];

  Future<List<StartStockSearch>> searchStock() async {
    if(startStockSearchList.isEmpty) {
      final Uri uri = Uri.https(
          'financialmodelingprep.com', '/api/v3/stock/list',
          {'apikey': kFinancialModelingPrepApi});
      final response = await Dio().getUri(uri);
      final data = response.data;
      var convertToList = StartStockSearch.convertToList(data).sublist(0, 50);
      startStockSearchList = convertToList;
      startStockSearchList.sort((a, b) {
        return a.symbol.toUpperCase().compareTo(b.symbol.toUpperCase());
      });
      return startStockSearchList;
    }else{
      return startStockSearchList;
    }
  }

  List<StartStockSearch> filter({String symbol}) {
    var list = startStockSearchList
        .where((stock) => (stock.symbol.contains(symbol)))
        .toList();
    if (list.isNotEmpty) {
      startStockSearchListTemp.clear();
      startStockSearchListTemp.addAll(list);
    }
    return startStockSearchListTemp;
  }

  Future<List<StartStockSearch>> fetchCache() async {
 /*   startStockSearchListCache.clear();
    var rawString= await rootBundle.loadString('assets/stock.json');
    var jsonData= convert.jsonDecode(rawString);
     startStockSearchListCache = StartStockSearch.convertToList(jsonData).sublist(0, 50);
    startStockSearchListCache.sort((a, b) {
    return a.symbol.toUpperCase().compareTo(b.symbol.toUpperCase());
    });*/
    return startStockSearchList;
  }
}
