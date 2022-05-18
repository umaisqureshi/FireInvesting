import 'dart:async';
import 'package:MOT/helpers/color/color_helper.dart';
import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/portfolio/widgets/heading/portfolio_heading.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'transaction_sheet.dart';

//import 'portfolio/portfolio_tabs.dart';
import 'package:MOT/crypto_portfolio/repo/portfolio_repo.dart';
import 'portfolio_item.dart';
import 'package:MOT/crypto_portfolio/repo/market_coin_item.dart';

class Tabs extends StatefulWidget {
  Tabs(
      {this.toggleTheme,
      this.savePreferences,
      this.handleUpdate,
      this.darkEnabled,
      this.themeMode,
      this.switchOLED,
      this.darkOLED});

  final Function toggleTheme;
  final Function handleUpdate;
  final Function savePreferences;

  final bool darkEnabled;
  final String themeMode;

  final Function switchOLED;
  final bool darkOLED;

  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _textController = new TextEditingController();
  int _tabIndex = 0;

  bool isSearching = false;
  String filter;

  bool sheetOpen = false;

  _handleFilter(value) {
    if (value == null) {
      isSearching = false;
      filter = null;
    } else {
      filter = value;
      isSearching = true;
    }
    _filterMarketData();
    setState(() {});
  }

  _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  _stopSearch() {
    setState(() {
      isSearching = false;
      filter = null;
      _textController.clear();
      _filterMarketData();
    });
  }

  _handleTabChange() {
    _tabIndex = _tabController.animation.value.round();
    if (isSearching) {
      _stopSearch();
    } else {
      setState(() {});
    }
  }

  _openTransaction() {
    setState(() {
      sheetOpen = true;
    });
    _scaffoldKey.currentState
        .showBottomSheet((BuildContext context) {
          return new TransactionSheet(
            () {
              setState(() {
                _makePortfolioDisplay();
              });
            },
            marketListData,
          );
        })
        .closed
        .whenComplete(() {
          setState(() {
            sheetOpen = false;
          });
        });
  }

  _makePortfolioDisplay() {
    print("making portfolio display");
    Map portfolioTotals = {};
    List neededPriceSymbols = [];

    portfolioMap.forEach((coin, transactions) {
      num quantityTotal = 0;
      transactions.forEach((value) {
        quantityTotal += value["quantity"];
      });
      portfolioTotals[coin] = quantityTotal;
      neededPriceSymbols.add(coin);
    });

    portfolioDisplay = [];
    num totalPortfolioValue = 0;
    marketListData.forEach((coin) {
      String symbol = coin["CoinInfo"]["Name"];
      if (neededPriceSymbols.contains(symbol) && portfolioTotals[symbol] != 0) {
        portfolioDisplay.add({
          "symbol": symbol,
          "price_usd": coin["RAW"]["USD"]["PRICE"],
          "percent_change_24h": coin["RAW"]["USD"]["CHANGEPCT24HOUR"],
          "percent_change_1h": coin["RAW"]["USD"]["CHANGEPCTHOUR"],
          "total_quantity": portfolioTotals[symbol],
          "id": coin["CoinInfo"]["Id"],
          "name": coin["CoinInfo"]["FullName"],
          "CoinInfo": coin["CoinInfo"]
        });
        totalPortfolioValue +=
            (portfolioTotals[symbol] * coin["RAW"]["USD"]["PRICE"]);
      }
    });

    num total24hChange = 0;
    num total1hChange = 0;
    portfolioDisplay.forEach((coin) {
      total24hChange += (coin["percent_change_24h"] *
          ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));
      total1hChange += (coin["percent_change_1h"] * ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));

      print("Percent_Change_1h Value : ${total1hChange}");
      print("Percent_Change_1h : ${coin["percent_change_1h"]}");
      print("price_usd : ${coin["price_usd"]}");
      print("total_quantity : ${coin["total_quantity"]}");
      print("Total Portfolio Value : $totalPortfolioValue");
    });

    totalPortfolioStats = {
      "value_usd": totalPortfolioValue,
      "percent_change_24h": total24hChange,
      "percent_change_1h": total1hChange
    };

    _sortPortfolioDisplay();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.animation.addListener(() {
      if (_tabController.animation.value.round() != _tabIndex) {
        _handleTabChange();
      }
    });

    _makePortfolioDisplay();
    _filterMarketData();
    _refreshMarketPage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _marketKey,
      onRefresh: () => _refreshMarketPage(),
      child: new Scaffold(
          key: _scaffoldKey,
          floatingActionButton: _tabIndex == 0 ? _transactionFAB(context) : null,
          body:  SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  PortfolioHeadingSection(globalKey:_scaffoldKey,showAction: true,title: "Crypto",subtitle: "portfolio",),

                  Container(
                    height: 50.0,
                    child: new TabBar(
                      controller: _tabController,
                      unselectedLabelColor: kBlueGray(500),
                      indicatorColor: kTextColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      /*indicator: BoxDecoration(
                          color: kTextColor,
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          border: Border.all(color: kTextColor)
                      ),*/
                      tabs: <Tab>[
                        new Tab(icon: new Icon(Icons.person)),
                        new Tab(icon: new Icon(Icons.filter_list)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: _tabController,
                      children: [portfolioPage(context), marketPage(context)],
                    ),
                  ),
                ],
              ),
            ),
          ),),
    );
  }

  Widget _transactionFAB(BuildContext context) {
    return sheetOpen
        ? new FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(Icons.close),
            foregroundColor: Theme.of(context).iconTheme.color,
            backgroundColor: Theme.of(context).accentIconTheme.color,
            elevation: 4.0,
            tooltip: "Close Transaction",
          )
        : new FloatingActionButton.extended(
            onPressed: _openTransaction,
            icon: Icon(Icons.add),
            label: new Text("Add Transaction"),
            foregroundColor: Theme.of(context).iconTheme.color,
            backgroundColor: Theme.of(context).accentIconTheme.color,
            elevation: 4.0,
            tooltip: "Add Transaction",
          );
  }

  final portfolioColumnProps = [.25, .35, .3];

  Future<Null> _refreshPortfolioPage() async {
    await getMarketData();
    getGlobalData();
    _makePortfolioDisplay();
    _filterMarketData();
    setState(() {});
  }

  List portfolioSortType = ["holdings", true];
  List sortedPortfolioDisplay;

  _sortPortfolioDisplay() {
    sortedPortfolioDisplay = portfolioDisplay;
    if (portfolioSortType[1]) {
      if (portfolioSortType[0] == "holdings") {
        sortedPortfolioDisplay.sort((a, b) =>
            (b["price_usd"] * b["total_quantity"])
                .toDouble()
                .compareTo((a["price_usd"] * a["total_quantity"]).toDouble()));
      } else {
        sortedPortfolioDisplay.sort((a, b) =>
            b[portfolioSortType[0]].compareTo(a[portfolioSortType[0]]));
      }
    } else {
      if (portfolioSortType[0] == "holdings") {
        sortedPortfolioDisplay.sort((a, b) =>
            (a["price_usd"] * a["total_quantity"])
                .toDouble()
                .compareTo((b["price_usd"] * b["total_quantity"]).toDouble()));
      } else {
        sortedPortfolioDisplay.sort((a, b) =>
            a[portfolioSortType[0]].compareTo(b[portfolioSortType[0]]));
      }
    }
  }

  final PageStorageKey _marketKey = new PageStorageKey("market");
  final PageStorageKey _portfolioKey = new PageStorageKey("portfolio");

  Widget portfolioPage(BuildContext context) {
    return new RefreshIndicator(
        key: _portfolioKey,
        onRefresh: _refreshPortfolioPage,
        child: new CustomScrollView(
          slivers: <Widget>[
            new SliverList(
                delegate: new SliverChildListDelegate(<Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: new Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("Total Portfolio Value",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white38),),
                          new Text('\$${compactText(totalPortfolioStats["value_usd"])}',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .apply(fontSizeFactor: 2.2)),
                        ],
                      ),
                      new Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("1h Change",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white38)),
                          new Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1.0)),
                          new Text(determineTextPercentageBasedOnChange(double.parse(totalPortfolioStats["percent_change_1h"].toString())),
                              style:
                                  Theme.of(context).primaryTextTheme.body2.apply(
                                        color: determineColorBasedOnChange(double.parse(totalPortfolioStats["percent_change_1h"].toString())),
                                        fontSizeFactor: 1.4,
                                      ))
                        ],
                      ),
                      new Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("24h Change",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white38)),
                          new Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1.0)),
                          new Text(determineTextPercentageBasedOnChange(double.parse(totalPortfolioStats["percent_change_24h"].toString())),
                              style:
                              Theme.of(context).primaryTextTheme.body2.apply(
                                color: determineColorBasedOnChange(double.parse(totalPortfolioStats["percent_change_24h"].toString())),
                                fontSizeFactor: 1.4,
                              ))
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              new Container(
                margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        bottom: new BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1.0))),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new InkWell(
                      onTap: () {
                        if (portfolioSortType[0] == "symbol") {
                          portfolioSortType[1] = !portfolioSortType[1];
                        } else {
                          portfolioSortType = ["symbol", false];
                        }
                        setState(() {
                          _sortPortfolioDisplay();
                        });
                      },
                      child: new Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width *
                            portfolioColumnProps[0],
                        child: portfolioSortType[0] == "symbol"
                            ? new Text(
                                portfolioSortType[1] == true
                                    ? "Currency " + upArrow
                                    : "Currency " + downArrow,
                                style: Theme.of(context).textTheme.body2)
                            : new Text(
                                "Currency",
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .apply(color: Theme.of(context).hintColor),
                              ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        if (portfolioSortType[0] == "holdings") {
                          portfolioSortType[1] = !portfolioSortType[1];
                        } else {
                          portfolioSortType = ["holdings", true];
                        }
                        setState(() {
                          _sortPortfolioDisplay();
                        });
                      },
                      child: new Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width *
                            portfolioColumnProps[1],
                        child: portfolioSortType[0] == "holdings"
                            ? new Text(
                                portfolioSortType[1] == true
                                    ? "Holdings " + downArrow
                                    : "Holdings " + upArrow,
                                style: Theme.of(context).textTheme.body2)
                            : new Text("Holdings",
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .apply(color: Theme.of(context).hintColor)),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        if (portfolioSortType[0] == "percent_change_24h") {
                          portfolioSortType[1] = !portfolioSortType[1];
                        } else {
                          portfolioSortType = ["percent_change_24h", true];
                        }
                        setState(() {
                          _sortPortfolioDisplay();
                        });
                      },
                      child: new Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width *
                            portfolioColumnProps[2],
                        child: portfolioSortType[0] == "percent_change_24h"
                            ? new Text(
                                portfolioSortType[1] == true
                                    ? "Price/24h " + downArrow
                                    : "Price/24h " + upArrow,
                                style: Theme.of(context).textTheme.body2)
                            : new Text("Price/24h",
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .apply(color: Theme.of(context).hintColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
            portfolioMap.isNotEmpty
                ? new SliverList(
                    delegate: new SliverChildBuilderDelegate(
                        (context, index) => new PortfolioListItem(
                            sortedPortfolioDisplay[index],
                            portfolioColumnProps),
                        childCount: sortedPortfolioDisplay != null
                            ? sortedPortfolioDisplay.length
                            : 0))
                : new SliverFillRemaining(
                    child: new Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                                "Your portfolio is empty. Add a transaction!",
                                style: Theme.of(context).textTheme.caption),
                            new Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0)),
                            new RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: _openTransaction,
                              child: new Text("New Transaction",
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .apply(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                            )
                          ],
                        ))),
          ],
        ));
  }

  final marketColumnProps = [.32, .35, .28];
  List filteredMarketData;
  Map globalData;

  Future<Null> getGlobalData() async {
    // var response = await http.get(
    //     Uri.encodeFull("https://api.coinmarketcap.com/v1/global-metrics/quotes/latest"),
    //     headers: {"Accept": "application/json"});

    // globalData = new JsonDecoder().convert(response.body)["data"]["quotes"]["USD"];
    globalData = null;
  }

  Future<Null> _refreshMarketPage() async {
    await getMarketData();
    await getGlobalData();
    _makePortfolioDisplay();
    _filterMarketData();
    setState(() {});
  }

  _filterMarketData() {
    print("filtering market data");
    filteredMarketData = marketListData;
    if (filter != "" && filter != null) {
      List tempFilteredMarketData = [];
      filteredMarketData.forEach((item) {
        if (item["CoinInfo"]["Name"]
                .toLowerCase()
                .contains(filter.toLowerCase()) ||
            item["CoinInfo"]["FullName"]
                .toLowerCase()
                .contains(filter.toLowerCase())) {
          tempFilteredMarketData.add(item);
        }
      });
      filteredMarketData = tempFilteredMarketData;
    }
    _sortMarketData();
  }

  List marketSortType = ["MKTCAP", true];

  _sortMarketData() {
    if (filteredMarketData == [] || filteredMarketData == null) {
      return;
    }
    // highest to lowest
    if (marketSortType[1]) {
      if (marketSortType[0] == "MKTCAP" ||
          marketSortType[0] == "TOTALVOLUME24H" ||
          marketSortType[0] == "CHANGEPCT24HOUR") {
        print(filteredMarketData);
        filteredMarketData.sort((a, b) =>
            (b["RAW"]["USD"][marketSortType[0]] ?? 0)
                .compareTo(a["RAW"]["USD"][marketSortType[0]] ?? 0));
        if (marketSortType[0] == "MKTCAP") {
          print("adding ranks to filteredMarketData");
          int i = 1;
          for (Map coin in filteredMarketData) {
            coin["rank"] = i;
            i++;
          }
        }
      } else {
        // Handle sorting by name
        filteredMarketData.sort((a, b) =>
            (b["CoinInfo"][marketSortType[0]] ?? 0)
                .compareTo(a["CoinInfo"][marketSortType[0]] ?? 0));
      }
      // lowest to highest
    } else {
      if (marketSortType[0] == "MKTCAP" ||
          marketSortType[0] == "TOTALVOLUME24H" ||
          marketSortType[0] == "CHANGEPCT24HOUR") {
        filteredMarketData.sort((a, b) =>
            (a["RAW"]["USD"][marketSortType[0]] ?? 0)
                .compareTo(b["RAW"]["USD"][marketSortType[0]] ?? 0));
      } else {
        filteredMarketData.sort((a, b) =>
            (a["CoinInfo"][marketSortType[0]] ?? 0)
                .compareTo(b["CoinInfo"][marketSortType[0]] ?? 0));
      }
    }
  }

  Widget marketPage(BuildContext context) {
    return filteredMarketData != null
        ? new CustomScrollView(
          slivers: <Widget>[
            new SliverList(
                delegate: new SliverChildListDelegate(<Widget>[
              globalData != null && isSearching != true
                  ? new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text("Total Market Cap",
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .apply(
                                          color:
                                              Theme.of(context).hintColor)),
                              new Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1.0)),
                              new Text("Total 24h Volume",
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .apply(
                                          color:
                                              Theme.of(context).hintColor)),
                            ],
                          ),
                          new Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1.0)),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                  "\$" +
                                      normalizeNum(
                                          globalData["total_market_cap"]),
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .apply(
                                          fontSizeFactor: 1.2,
                                          fontWeightDelta: 2)),
                              new Text(
                                  "\$" +
                                      normalizeNum(
                                          globalData["total_volume_24h"]),
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .apply(
                                          fontSizeFactor: 1.2,
                                          fontWeightDelta: 2)),
                            ],
                          )
                        ],
                      ))
                  : new Container(),
              new Container(
                margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        bottom: new BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1.0))),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new InkWell(
                      onTap: () {
                        if (marketSortType[0] == "Name") {
                          marketSortType[1] = !marketSortType[1];
                        } else {
                          marketSortType = ["Name", false];
                        }
                        setState(() {
                          _sortMarketData();
                        });
                      },
                      child: new Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width *
                            marketColumnProps[0],
                        child: marketSortType[0] == "Name"
                            ? new Text(
                                marketSortType[1]
                                    ? "Currency " + upArrow
                                    : "Currency " + downArrow,
                                style: Theme.of(context).textTheme.body2)
                            : new Text("Currency",
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .apply(
                                        color:
                                            Theme.of(context).hintColor)),
                      ),
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width *
                          marketColumnProps[1],
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new InkWell(
                              onTap: () {
                                if (marketSortType[0] == "MKTCAP") {
                                  marketSortType[1] = !marketSortType[1];
                                } else {
                                  marketSortType = ["MKTCAP", true];
                                }
                                setState(() {
                                  _sortMarketData();
                                });
                              },
                              child: new Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: marketSortType[0] == "MKTCAP"
                                    ? new Text(
                                        marketSortType[1]
                                            ? "Market Cap " + downArrow
                                            : "Market Cap " + upArrow,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2)
                                    : new Text("Market Cap",
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .apply(
                                                color: Theme.of(context)
                                                    .hintColor)),
                              )),
                          new Text("/",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .apply(
                                      color: Theme.of(context).hintColor)),
                          new InkWell(
                            onTap: () {
                              if (marketSortType[0] == "TOTALVOLUME24H") {
                                marketSortType[1] = !marketSortType[1];
                              } else {
                                marketSortType = ["TOTALVOLUME24H", true];
                              }
                              setState(() {
                                _sortMarketData();
                              });
                            },
                            child: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: marketSortType[0] == "TOTALVOLUME24H"
                                  ? new Text(
                                      marketSortType[1]
                                          ? "24h " + downArrow
                                          : "24h " + upArrow,
                                      style:
                                          Theme.of(context).textTheme.body2)
                                  : new Text("24h",
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .apply(
                                              color: Theme.of(context)
                                                  .hintColor)),
                            ),
                          )
                        ],
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        if (marketSortType[0] == "CHANGEPCT24HOUR") {
                          marketSortType[1] = !marketSortType[1];
                        } else {
                          marketSortType = ["CHANGEPCT24HOUR", true];
                        }
                        setState(() {
                          _sortMarketData();
                        });
                      },
                      child: new Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width *
                            marketColumnProps[2],
                        child: marketSortType[0] == "CHANGEPCT24HOUR"
                            ? new Text(
                                marketSortType[1] == true
                                    ? "Price/24h " + downArrow
                                    : "Price/24h " + upArrow,
                                style: Theme.of(context).textTheme.body2)
                            : new Text("Price/24h",
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .apply(
                                        color:
                                            Theme.of(context).hintColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
            filteredMarketData.isEmpty
                ? new SliverList(
                    delegate: new SliverChildListDelegate(<Widget>[
                    new Container(
                      padding: const EdgeInsets.all(30.0),
                      alignment: Alignment.topCenter,
                      child: new Text("No results found",
                          style: Theme.of(context).textTheme.caption),
                    )
                  ]))
                : new SliverList(
                    delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) =>
                            new CoinListItem(filteredMarketData[index],
                                marketColumnProps),
                        childCount: filteredMarketData == null
                            ? 0
                            : filteredMarketData.length))
          ],
        )
        : new Container(
            child: new Center(child: new CircularProgressIndicator()),
          );
  }
}