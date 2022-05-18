import 'package:MOT/models/storage/storage.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/shared/styles.dart';
import 'package:MOT/widgets/portfolio/portfolio_stonks.dart';
import 'package:MOT/widgets/portfolio/widgets/heading/portfolio_heading.dart';
import 'package:MOT/widgets/profile/widgets/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:MOT/helpers/color/color_helper.dart';
import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/models/profile/stock_chart.dart';
import 'package:MOT/models/profile/stock_profile.dart';
import 'package:MOT/models/profile/stock_quote.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:MOT/widgets/profile/widgets/profile/profile_graph.dart';
import 'package:MOT/widgets/profile/widgets/profile/profile_summary.dart';

import 'package:MOT/widgets/profile/widgets/styles.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Profile extends StatefulWidget {

  final bool isSaved;
  final Color color;
  final StockQuote stockQuote;
  final StockProfile stockProfile;
  final List<StockChart> stockChart;
  final List<StockChart> stockChart5Y;
  final List<StockChart> stockChart1M;
  final List<StockChart> stockChart3M;
  final List<StockChart> stockChart6M;
  final List<StockChart> stockChart1D;
  final List<StockChart> stockChart5D;

  Profile({
    @required this.color,
    @required this.stockProfile,
    @required this.stockQuote,
    @required this.stockChart,
    @required this.stockChart1D,
    @required this.stockChart5D,
    @required this.stockChart5Y,
    @required this.stockChart1M,
    @required this.stockChart3M,
    @required this.stockChart6M,
    this.globalKey,
    this.isSaved
  });
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int tabIndex = 0;

  List<StockChart> getChart(index){
    if(index==1){
      return widget.stockChart5D;
    }else if(index==2){
      return widget.stockChart1M;
    }else if(index==3){
      return widget.stockChart3M;
    }else if(index==4){
      return widget.stockChart6M;
    } else if(index==5){
      return widget.stockChart;
    }else if(index==6){
      return widget.stockChart5Y;
    }else{
      return widget.stockChart1D;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 10, right: 10, top: 18),
      children: <Widget>[
        PortfolioHeadingSection(globalKey:widget.globalKey, title: widget.stockQuote.symbol, subtitle: widget.stockQuote.name,showAction: false,widget:  WatchlistButtonWidget(
          storageModel: StorageModel(
              symbol: widget.stockQuote.symbol,
              companyName: widget.stockQuote.name
          ),
          isSaved: widget.isSaved,
          color: Colors.white,
        ),),
        SizedBox(height: 10,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0x80212121),
            border: Border.all(width: 0.9, color: kHintColor),
            boxShadow: [
              BoxShadow(
                color: const Color(0x66000000),
                offset: Offset(0, 0),
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              _buildPrice(),
              /*Container(
                height: 250,
                padding: EdgeInsets.only(top: 26),
                child: SimpleTimeSeriesChart(
                  chart: this.stockChart,
                  color: this.color
                )
              ),*/
              Container(
                height: 300,
                child: SfCartesianChart(
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: DateTimeAxis(
                      enableAutoIntervalOnZooming: true,
                      interval: 1,
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      majorGridLines: MajorGridLines(
                          color: Colors.white10, dashArray: <double>[5, 5]),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    primaryYAxis: CategoryAxis(
                        isVisible:false,
                        opposedPosition: false,
                        majorGridLines: MajorGridLines(color: Colors.transparent),
                        labelStyle: TextStyle(color: Colors.transparent)),
                    axes: [ NumericAxis(
                        opposedPosition: true,
                        name: 'yAxis1',
                        labelFormat: '{value}',
                        numberFormat: NumberFormat.compactCurrency(symbol: '\$'),
                        majorGridLines: MajorGridLines(color: Colors.white10),
                        labelStyle: TextStyle(color: Colors.white)),],
                    legend: Legend(isVisible: false),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    crosshairBehavior: CrosshairBehavior(enable: true),
                    series: <ChartSeries<SalesData, DateTime>>[
                      SplineAreaSeries<SalesData, DateTime>(
                        borderColor: Colors.amber,
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(widget.color.red, widget.color.green, widget.color.blue, 0.5),
                                Color.fromRGBO(widget.color.red, widget.color.green, widget.color.blue, 0.5),
                              ],
                              stops:[
                                0.2,
                                0.6
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topRight
                          ),
                          dataSource: getChart(tabIndex).map((e) => SalesData(DateTime.parse(e.date), e.close)).toList(),
                          color: Colors.amber,
                          yAxisName: 'yAxis1',
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) =>
                          sales.sales,
                          //  markerSettings: MarkerSettings(isVisible:true),
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(
                              isVisible: false,
                              textStyle: TextStyle(color: Colors.white))),
                    ]),
              ),
              SizedBox(height: 10,),
              _buildStocksChartSection((index){
                setState(() {
                  tabIndex = index;
                });
              }),
              SizedBox(height: 10,),
            ],
          ),
        ),
        StatisticsWidget(
          quote: widget.stockQuote,
          profile: widget.stockProfile,
        )
      ],
    );
  }

  Widget _buildStocksChartSection(ValueChanged<int> onChange) {

    return DefaultTabController(
      length: 7,
      initialIndex: tabIndex,
      child: Container(
        height: 30,
        child: TabBar(
          onTap: (index){
            onChange(index);
          },
            unselectedLabelColor: kBlueGray(500),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            indicator: BoxDecoration(
                color: kTextColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: kTextColor)
            ),
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("1D"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("5D"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("1M"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("3M"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("6M"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("1Y"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("5Y"),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget _buildPrice() {
    return Padding(
      padding: const EdgeInsets.only(top:15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Text(
        'Stock Price',
        style: TextStyle(
          fontSize: 10,
          color: const Color(0x80ffffff),
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.left,
      ),
          Text('\$${formatText(widget.stockQuote.price)}', style: priceStyle),
          SizedBox(height: 8),
          Text('${determineTextBasedOnChange(widget.stockQuote.change)}  (${determineTextPercentageBasedOnChange(widget.stockQuote.changesPercentage)})',
            style: determineTextStyleBasedOnChange(widget.stockQuote.change)
          )
        ],
      ),
    );
  }
}