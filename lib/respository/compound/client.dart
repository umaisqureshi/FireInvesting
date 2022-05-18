import 'package:MOT/helpers/database_helper.dart';
import 'package:MOT/helpers/http_helper.dart';
import 'package:MOT/keys/api_keys.dart';
import 'package:MOT/models/compound_cal/compound_calculator_model.dart';
import 'package:MOT/models/dividend/DividendSP.dart';
import 'package:MOT/models/dividend/dividendModel.dart';
import 'package:MOT/models/dividend/dividendSearch.dart';
import 'package:MOT/models/search/search.dart';
import 'package:dio/dio.dart';
import 'package:sembast/sembast.dart';
import 'package:MOT/models/dividend/dividendYieldModel.dart';

class CompoundClient extends FetchClient {
  final StoreRef<int, Map<String, dynamic>> _store =
      intMapStoreFactory.store('compound_history');

  Future<Database> get _database async =>
      await DatabaseManager.instance.database;

  // Gets all the symbols stored.
  Future<List<DividendSearch>> fetch() async {
    final finder = Finder(sortOrders: [SortOrder(Field.key, false)]);
    final response = await _store.find(await _database, finder: finder);
    return response
        .map((snapshot) => DividendSearch(
            symbol: snapshot.value['symbol'].toString(),
            quantity: snapshot.value['quantity']))
        .toList();
  }

  Future<void> save({CompoundCalculatorModel ccModal}) async {
    await _store.add(await _database, {
      'name' : ccModal.name,
      'initialInvestment': ccModal.initialInvestment,
      'interestRate': ccModal.interestRate,
      'yearToMonths': ccModal.yearToMonths,
      'months': ccModal.months,
      'interval': ccModal.interval,
      'initialAmount': ccModal.initialAmount,
    });
  }

  Future<void> delete({String symbol}) async {
    final finder = Finder(filter: Filter.matches('name', symbol));
    final response = await _store.findKey(await _database, finder: finder);
    final deleteFinder = Finder(filter: Filter.byKey(response));
    await _store.delete(await _database, finder: deleteFinder);
  }

  DividendYieldModel calculateYield(
      dividendPerShare, costPerShare, taxPercent, noOfShares) {
    double dividendYield = (dividendPerShare / costPerShare) * 100;
    double taxedYield = ((dividendYield / 100) * (taxPercent / 100)) * 100;
    double yieldAfterTax = dividendYield - taxedYield; //%
    double totalCost = noOfShares * costPerShare;
    double yearlyDividend = dividendPerShare * noOfShares;
    double taxAmount = (taxPercent * yearlyDividend) / 100;
    double yearlyDividendAfterTax = yearlyDividend - taxAmount;
    double quarterlyDividend = yearlyDividendAfterTax / 4;
    double monthlyDividend = yearlyDividendAfterTax / 12;

    return DividendYieldModel(
        yield: dividendYield,
        taxYield: taxedYield,
        yieldAfterTax: yieldAfterTax,
        taxAmount: taxAmount,
        cost: totalCost,
        yearly: yearlyDividendAfterTax,
        quarterly: quarterlyDividend,
        monthly: monthlyDividend);
  }
}
