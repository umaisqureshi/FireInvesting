import 'package:MOT/bloc/profile/profile_bloc.dart';
import 'package:MOT/helpers/color/color_helper.dart';
import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/widgets/portfolio/see_more.dart';
import 'package:MOT/widgets/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MOT/bloc/portfolio/portfolio_bloc.dart';
import 'package:MOT/models/data_overview.dart';
import 'package:MOT/models/profile/market_index.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/shared/styles.dart';
import 'package:MOT/widgets/portfolio/widgets/content/portfolio_index.dart';
import 'package:MOT/widgets/portfolio/widgets/content/portfolio_stonk.dart';
import 'package:MOT/widgets/widgets/empty_screen.dart';
import 'package:MOT/widgets/widgets/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class PortfolioStonksSection extends StatefulWidget {
  static const _indexNameStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static const _indexMoreStyle = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 15,
      decoration: TextDecoration.underline,
      fontStyle: FontStyle.italic);
  static const _indexHeaderTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor);
  static const _indexHeaderStyle = DataGridHeaderCellStyle(
      backgroundColor: Colors.transparent, textStyle: _indexHeaderTextStyle);
  static const _indexCellStyle = DataGridCellStyle(
      backgroundColor: Colors.transparent,
      textStyle: TextStyle(color: Colors.white));

  @override
  _PortfolioStonksSectionState createState() => _PortfolioStonksSectionState();
}

class _PortfolioStonksSectionState extends State<PortfolioStonksSection> {
  final DataGridController _dataGridController = DataGridController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (BuildContext context, PortfolioState state) {
        if (state is PortfolioInitial) {
          BlocProvider.of<PortfolioBloc>(context).add(FetchPortfolioData());}
        if (state is PortfolioError) {
          return Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            child: EmptyScreen(message: state.message),
          );
        }
        if (state is PortfolioLoaded) {
          return Column(
            children: <Widget>[
              _buildInvestmentSection(context),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.center,
                  child: _getDataGrid(
                      indexes: state.indexes, name: "Major Indexes")),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.center,
                  child: _getDataGrid(
                      indexes: state.active.marketActiveModelData,
                      name: "Most Active")),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.center,
                  child: _getDataGrid(
                      indexes: state.gainer.marketActiveModelData,
                      name: "Most Gainer")),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.center,
                  child: _getDataGrid(
                      indexes: state.looser.marketActiveModelData,
                      name: "Most Looser")),
              SizedBox(
                height: 20,
              ),
              state.stocks!=null? Align(
                  alignment: Alignment.center,
                  child: _getDataGrid(
                      indexes: state.stocks, name: "Stocks")):Container(),

              SizedBox(
                height: 10,
              ),
             /* _buildStocksChartSection(),*/
              // _buildStocksSection(stocks: state.stocks)
            ],
          );
        }
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          child: LoadingIndicatorWidget(),
        );
      },
    );
  }

 /* Widget _buildStocksChartSection() {

    return DefaultTabController(
      length: 7,
      child: Container(
        padding: EdgeInsets.only(top: 8.0),
        height: 360,
        decoration: BoxDecoration(
          borderRadius: kSharpBorder,
          color: const Color(0x80212121),
        ),
        child: Column(
          children: [
            Container(
              child: SfCartesianChart(
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  plotAreaBorderWidth: 0,
                  primaryXAxis: DateTimeAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  enableAutoIntervalOnZooming: true,
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
                      labelFormat: '{value}%',
                      majorGridLines: MajorGridLines(color: Colors.white10),
                      labelStyle: TextStyle(color: Colors.white)),],
                  legend: Legend(isVisible: false),

                  tooltipBehavior: TooltipBehavior(enable: true),
                  crosshairBehavior: CrosshairBehavior(enable: true),
                  series: <ChartSeries<SalesData, DateTime>>[
                    RangeAreaSeries<SalesData, DateTime>(
                        dataSource: <SalesData>[
                          SalesData(DateTime.parse("2021-03-05 16:00:00"), '40', '30'),
                          SalesData(DateTime.parse("2021-03-05 15:59:00"), '40', '40'),
                          SalesData(DateTime.parse("2021-03-05 15:58:00"), '40', '60'),
                          SalesData(DateTime.parse("2021-03-05 15:57:00"), '40', '80'),
                          SalesData(DateTime.parse("2021-03-05 15:56:00"), '40', '20'),
                          SalesData(DateTime.parse("2021-03-05 15:55:00"), '40', '50'),
                          SalesData(DateTime.parse("2021-03-05 15:54:00"), '40', '36'),
                          SalesData(DateTime.parse("2021-03-05 15:53:00"), '40', '80'),
                          SalesData(DateTime.parse("2021-03-05 15:52:00"), '40', '90'),
                          SalesData(DateTime.parse("2021-03-05 15:51:00"), '40', '10'),
                        ],
                        color: Colors.amber,
                        yAxisName: 'yAxis1',
                        borderColor: Colors.amber,
                        borderWidth: 2,
                        opacity: 0.5,
                        borderDrawMode: RangeAreaBorderMode.excludeSides,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        highValueMapper: (SalesData sales, _) =>
                            double.parse(sales.ss),
                        lowValueMapper: (SalesData sales, _) =>
                            double.parse(sales.ss),
                        markerSettings: MarkerSettings(isVisible:true),
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(
                            isVisible: false,
                            textStyle: TextStyle(color: Colors.white))),
                  ]),
            ),
            Container(
              height: 30,
              child: TabBar(
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
          ],
        ),
      ),
    );
  }*/



  _getDataGrid({List<dynamic> indexes, String name}) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                name,
                style: PortfolioStonksSection._indexNameStyle,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SeeMore(indexes: indexes,)));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  "SeeMore",
                  style: PortfolioStonksSection._indexMoreStyle,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        SfDataGridTheme(
          data: SfDataGridThemeData(
              headerStyle: PortfolioStonksSection._indexHeaderStyle,
              cellStyle: PortfolioStonksSection._indexCellStyle,
              gridLineColor: kHintColor,
              selectionStyle: PortfolioStonksSection._indexCellStyle,
              gridLineStrokeWidth: 0.3),
          child: SfDataGrid(
              onCellTap: (detail) {
                if (detail.rowColumnIndex.rowIndex < 1) {
                  return;
                }
                  var symbol = indexes[detail.rowColumnIndex.rowIndex-1].symbol;
                  BlocProvider
                      .of<ProfileBloc>(context)
                      .add(FetchProfileData(symbol: symbol));
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(symbol: symbol)));
                print(indexes[detail.rowColumnIndex.rowIndex - 1].symbol);
              },
              // gridLinesVisibility: GridLinesVisibility.none,
               verticalScrollPhysics: NeverScrollableScrollPhysics(),
              source: _ColumnTypesDataGridSource(list: indexes),
              columnWidthMode: ColumnWidthMode.fill,
              cellBuilder:
                  (BuildContext context, GridColumn column, int rowIndex) {
                if (column.mappingName == 'change') {
                  return Center(
                    child: Container(
                      child: Text(
                        indexes[rowIndex] is MarketIndexModel
                            ? '${determineTextBasedOnChange(indexes[rowIndex].change)}(${determineTextPercentageBasedOnChange(indexes[rowIndex].changesPercentage)})'
                            : '${determineTextBasedOnChange(indexes[rowIndex].change)}${indexes[rowIndex].changesPercentage}',
                        style: TextStyle(
                            color: determineColorBasedOnChange(
                                indexes[rowIndex].change)),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                else if (column.mappingName == 'price') {
                  return Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        determineArrowBasedOnChange(indexes[rowIndex].change),
                        Text(
                          indexes[rowIndex].price.toString(),
                          style: TextStyle(
                              color: determineColorBasedOnChange(
                                  indexes[rowIndex].change)),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                else {
                  return Container();
                }
              },
              columns: <GridColumn>[
                GridTextColumn(
                    mappingName: 'name',
                    headerText: 'Name',
                    textAlignment: Alignment.centerLeft,
                    headerTextAlignment: Alignment.centerLeft),
                GridWidgetColumn(
                  mappingName: 'change',
                  headerText: 'Change',
                ),
                GridWidgetColumn(
                  mappingName: 'price',
                  headerText: 'Price',
                ),
              ],
              controller: _dataGridController,
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.cell),
        ),
      ],
    );
  }

  Widget _buildInvestmentSection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 180.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.0),
        color: const Color(0x80212121),
        border: Border.all(width: 0.5, color: const Color(0xffffffff)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66000000),
            offset: Offset(0, 0),
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ComingSoon',
              style: TextStyle(
                fontSize: 25,
                color: const Color(0x80ffffff),
              ),
              textAlign: TextAlign.left,
            ),
           /* SizedBox(
              height: 10,
            ),
            Text(
              '\$1250.00',
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SvgPicture.string(
              '<svg viewBox="133.5 180.5 109.0 1.0" ><path transform="translate(133.5, 180.5)" d="M 0 0 L 109 0" fill="none" stroke="#ffffff" stroke-width="0.5" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
              allowDrawingOutsideViewBox: true,
            ),
            SizedBox(
              height: 10,
            ),*/
            /*Container(
              height: 50,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset("assets/images/average_price.png"),
                    title: Transform.translate(
                      offset: Offset(-25,0),
                      child: Text(
                        'Average Yield',
                        style: TextStyle(
                            fontSize: 14, color: Theme.of(context).hintColor),
                      ),
                    ),
                    subtitle: Transform.translate(
                      offset: Offset(-25,0),
                      child: Text(
                        '520.00',
                        style: TextStyle(
                            fontSize: 16,
                            color: kTextColor),
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset("assets/images/average_price.png"),
                    title: Text(
                      'Average Yield',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).hintColor),
                    ),
                    subtitle: Text(
                      '520.00',
                      style: TextStyle(
                          fontSize: 16,
                          color: kTextColor),
                    ),
                  )
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildIndexesSection({List<MarketIndexModel> indexes}) {
    return Container(
      height: 330,
      width: double.infinity,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        // scrollDirection: Axis.horizontal,
        itemCount: indexes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: PortfolioIndexWidget(index: indexes[index]),
          ));
        },
      ),
    );
  }

  Widget _buildStocksSection({List<StockOverviewModel> stocks}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: stocks.length,
        itemBuilder: (BuildContext context, int index) {
          return PortfolioStockCard(data: stocks[index]);
        });
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}

class _ColumnTypesDataGridSource extends DataGridSource<dynamic> {
  List<dynamic> list;

  _ColumnTypesDataGridSource({this.list});

  @override
  List<dynamic> get dataSource => list;


  @override
  Object getValue(dynamic model, String columnName) {
    switch (columnName) {
      case 'name':
        return model.name;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
