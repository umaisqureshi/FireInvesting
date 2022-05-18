import 'package:MOT/bloc/dividend/dividend_bloc.dart';
import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/dividend/dividendResultWidget.dart';
import 'package:MOT/widgets/dividend/dividendYieldResultWidget.dart';
import 'package:MOT/widgets/dividend/widgets/search_box/dividend_seach_box.dart';
import 'package:MOT/widgets/dividend/widgets/search_box/gernl_dividend_seach_box.dart';
import 'package:MOT/widgets/widgets/empty_screen.dart';
import 'package:MOT/widgets/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DividendCalculator extends StatefulWidget {
  final bool withSymbol;

  DividendCalculator({this.withSymbol});

  @override
  _DividendCalculatorState createState() => _DividendCalculatorState();
}

class _DividendCalculatorState extends State<DividendCalculator>
    with TickerProviderStateMixin {
  TabController _tabController;
  String symbol;
  int shareOwned = 0;
  final double animationRange = 5;
  AnimationController animationController;
  final Duration animationDuration = const Duration(milliseconds: 500);
  bool isLoading = false;
  int _tabIndex = 0;

  double dividendPerShare = 0.0;
  double costPerShare = 0.0;
  int noOfShares = 0;
  double taxPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.animation.addListener(() {
      if (_tabController.animation.value.round() != _tabIndex) {
        _tabIndex = _tabController.animation.value.round();
      }
    });
    animationController =
        AnimationController(duration: animationDuration, vsync: this);
  }

  getOffSetAnimation() {
    return Tween(begin: 0.0, end: animationRange)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = getOffSetAnimation();
    return BlocBuilder<DividendBloc, DividendState>(
      builder: (BuildContext context, DividendState state) {
        return tabs(state, offsetAnimation);
      },
    );
  }

  Widget tabs(state, offsetAnimation) {
    return Column(
      children: [
        Container(
          height: 50.0,
          child: new TabBar(
            controller: _tabController,
            unselectedLabelColor: kBlueGray(500),
            indicatorColor: kTextColor,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Tab>[
              new Tab(
               /* icon: new Icon(Icons.calculate),
                text: "Online",*/
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Icon(Icons.calculate),
                   SizedBox(width: 5,),
                  Text("Calculator 1",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ],),
              ),
              new Tab(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.calculate),
                  SizedBox(width: 5,),
                  Text("Calculator 2",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ],),
                /*icon: new Icon(Icons.calculate),
                text: "Offline",*/
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Text(
                    "Calculate (Online) total Dividend based on Symbol",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: DividendSearchBoxWidget(
                      offsetAnimation: offsetAnimation,
                      onChangeSymbol: (value) {
                        setState(() => symbol = value);
                      },
                      onChangeShare: (value) {
                        setState(() => shareOwned = value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      width: double.infinity,
                      child: state is DividendLoading
                          ? LoadingIndicatorWidget()
                          : RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                if (symbol != null) {
                                  BlocProvider.of<DividendBloc>(context).add(
                                      FetchDividendData(
                                          symbol: symbol,
                                          quantity: shareOwned));
                                } else {
                                  animationController.forward(from: 0.0);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text(
                                'Calculate',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                    ),
                  ),
                  state is DividendLoaded
                      ? DividendResultWidget(
                          dividendSP: state.dividendSP,
                          shareOwned: shareOwned,
                        )
                      : Container(),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Calculate (Offline) total Dividend based on Tax",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38),
                  ),
                  SizedBox(height: 10,),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: GeneralDividendSearchBoxWidget(
                        dividendPerShare: (value) {
                          setState(() => dividendPerShare = value);
                        },
                        costPerShare: (value) {
                          setState(() => costPerShare = value);
                        },
                        numOfShare: (value) {
                          setState(() => noOfShares = value);
                        },
                        taxPercent: (value) {
                          setState(() => taxPercent = value);
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      width: double.infinity,
                      child: isLoading
                          ? LoadingIndicatorWidget()
                          : RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                BlocProvider.of<DividendBloc>(context).add(
                                    FetchDividendYield(
                                        dividendPerShare: dividendPerShare,
                                        costPerShare: costPerShare,
                                    noOfShares: noOfShares,
                                    taxPercent: taxPercent));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text(
                                'Calculate',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                    ),
                  ),
                  state is YieldLoaded
                      ? DividendYieldResultWidget(yieldModel: state.dividendYieldModel,)
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
