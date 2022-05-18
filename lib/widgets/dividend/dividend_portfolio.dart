import 'package:MOT/bloc/dividend/dividend_bloc.dart';
import 'package:MOT/bloc/profile/profile_bloc.dart';
import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/widgets/dividend/dividendResultWidget.dart';
import 'package:MOT/widgets/profile/profile.dart';
import 'package:MOT/widgets/widgets/empty_screen.dart';
import 'package:MOT/widgets/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DividendPortfolio extends StatefulWidget {

  @override
  _DividendPortfolioState createState() =>
      _DividendPortfolioState();
}

class _DividendPortfolioState extends State<DividendPortfolio>
    with TickerProviderStateMixin {
  String symbol;
  int shareOwned = 0;
  final double animationRange = 5;
  AnimationController animationController;
  final Duration animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: animationDuration, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation =
        Tween(begin: 0.0, end: animationRange)
            .chain(CurveTween(curve: Curves.elasticIn))
            .animate(animationController)
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  animationController.reverse();
                }
              });
    return BlocBuilder<DividendBloc, DividendState>(
      builder: (BuildContext context, DividendState state) {
        if (state is UpdateDividend) {
          BlocProvider.of<DividendBloc>(context).add(FetchFromLocal());
        }
        return calculate(state, offsetAnimation);
      },
    );
  }

  double getTotalDividend(LoadedFromLocal state) {
    double totalDividendEarned = 0.0;
    state.sp.forEach((element) {
   //   if (element.dividendS.dividendYield != 0.0) {
        totalDividendEarned +=
            (((element.dividendP.close * element.dividendT.quantity) *
                    (element.dividendS.dividendYield)) /
                100);
    // }
    });
    return totalDividendEarned;
  }

  Widget calculate(state, offsetAnimation) {
    return Column(
      children: [
        state is LoadedFromLocal
            ? state.sp!=null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Portfolio Value",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white38),
                                        ),
                                        Text(
                                          '\$${compactText(state.sp.map((element) => element.dividendT.total).fold(0, (prev, amount) => prev + amount))}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total Dividend Yield",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white38),
                                        ),
                                        Text(
                                          '${determineTextPercentageBasedOnChange(state.sp.map((element) => element.dividendS.dividendYield).fold(0, (prev, amount) => prev + amount))}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Monthly Dividend",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white38),
                                        ),
                                        Text(
                                          '\$${compactText(getTotalDividend(state) / 12)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Quarter Dividend",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white38),
                                        ),
                                        Text(
                                          '\$${compactText(getTotalDividend(state) / 4)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Yearly Dividend",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white38),
                                        ),
                                        Text(
                                          '\$${compactText(getTotalDividend(state))}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: state.sp
                              .map((e) => InkWell(
                            onTap: (){
                              BlocProvider
                                  .of<ProfileBloc>(context)
                                  .add(FetchProfileData(symbol: e.dividendT.symbol));
                              Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(symbol: e.dividendT.symbol)));
                            },
                                child: DividendResultWidget(
                                      dividendSP: e,
                                      shareOwned: e.dividendT.quantity,
                                    ),
                              ))
                              .toList(),
                        ),
                        /*  Container(
                      height: 400,
                      child: ListView.builder(
                        itemCount: state.fetched.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("\$ " +
                                (state.fetched[index].quantity *
                                        state.sp[index].dividendP.close)
                                    .toStringAsFixed(2)),
                            subtitle: Text(
                              "Qty : ${state.fetched[index].quantity}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white38,
                              ),
                            ),
                            leading: Container(
                              width: 50,
                              height: 40,
                              child: Text(
                                state.fetched[index].symbol,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white38,
                                    ),
                                    text: "Dividend Yield : ",
                                    children: [
                                      TextSpan(
                                        text:
                                            "${state.sp[index].dividendS.dividendYield.toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white38,
                                    ),
                                    text: "Dividend : \$ ",
                                    children: [
                                      TextSpan(
                                        text: (((((state.sp[index].dividendP
                                                                    .close *
                                                                state
                                                                    .fetched[
                                                                        index]
                                                                    .quantity) *
                                                            state
                                                                .sp[index]
                                                                .dividendS
                                                                .dividendYield) /
                                                        100) *
                                                    (state.fetched[index]
                                                            .quantity *
                                                        state.sp[index]
                                                            .dividendP.close)) /
                                                100)
                                            .toStringAsFixed(2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),*/
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3,
                        left: 24,
                        right: 24),
                    child: EmptyScreen(
                        message: 'Looks like you don\'t have any Stocks'),
                  )
            : LoadingIndicatorWidget()
      ],
    );
  }
}
