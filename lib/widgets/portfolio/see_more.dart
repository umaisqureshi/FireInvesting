import 'package:MOT/helpers/color/color_helper.dart';
import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/models/profile/market_index.dart';
import 'package:MOT/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class SeeMore extends StatefulWidget {
  final List<dynamic> indexes;

  SeeMore({Key key, this.indexes}) : super(key: key);

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  static const _indexHeaderTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20, color: kTextColor);
  static const _indexHeaderStyle = DataGridHeaderCellStyle(
      backgroundColor: Colors.black12, textStyle: _indexHeaderTextStyle);
  static const _indexCellStyle = DataGridCellStyle(
      backgroundColor: Colors.transparent,
      textStyle: TextStyle(color: Colors.white));
  final DataGridController _dataGridController = DataGridController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
                headerStyle: _indexHeaderStyle,
                cellStyle: _indexCellStyle,
                gridLineColor: kHintColor,
                selectionStyle: _indexCellStyle,
                gridLineStrokeWidth: 0.3),
            child: SfDataGrid(
              headerGridLinesVisibility: GridLinesVisibility.none,
                horizontalScrollPhysics: NeverScrollableScrollPhysics(),
              //  verticalScrollPhysics: NeverScrollableScrollPhysics(),
                onCellTap: (detail) {
                  if (detail.rowColumnIndex.rowIndex < 1) {
                    return;
                  }
                  print(widget.indexes[detail.rowColumnIndex.rowIndex - 1].name);
                },
                // gridLinesVisibility: GridLinesVisibility.none,
                // verticalScrollPhysics: NeverScrollableScrollPhysics(),
                source: _ColumnTypesDataGridSource(list: widget.indexes),
                columnWidthMode: ColumnWidthMode.fill,
                cellBuilder:
                    (BuildContext context, GridColumn column, int rowIndex) {
                  if (column.mappingName == 'change') {
                    return Center(
                      child: Container(
                        child: Text(
                          widget.indexes[rowIndex] is MarketIndexModel
                              ? '${determineTextBasedOnChange(widget.indexes[rowIndex].change)}(${determineTextPercentageBasedOnChange(widget.indexes[rowIndex].changesPercentage)})'
                              : '${determineTextBasedOnChange(widget.indexes[rowIndex].change)}${widget.indexes[rowIndex].changesPercentage}',
                          style: TextStyle(
                              color: determineColorBasedOnChange(
                                  widget.indexes[rowIndex].change)),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else if (column.mappingName == 'price') {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          determineArrowBasedOnChange(
                              widget.indexes[rowIndex].change),
                          Text(
                            widget.indexes[rowIndex].price.toString(),
                            style: TextStyle(
                                color: determineColorBasedOnChange(
                                    widget.indexes[rowIndex].change)),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
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
        ),
      ),
    );
  }
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
