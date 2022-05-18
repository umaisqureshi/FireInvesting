import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/models/dividend/DividendSP.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/profile/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOT/models/dividend/dividendYieldModel.dart';

class DividendYieldResultWidget extends StatelessWidget {
  final DividendYieldModel yieldModel;
  DividendYieldResultWidget({@required this.yieldModel});

  static Text _renderText(dynamic text) {
    return text != null ? Text(text,) : Text('-');
  }

  List<Widget> _leftColumn() {
    return [
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Dividend Yield', style: subtitleStyle),
          trailing: _renderText(determineTextPercentageBasedOnChange(yieldModel.yield))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Tax Yield', style: subtitleStyle),
          trailing: _renderText(determineTextPercentageBasedOnChange(yieldModel.taxYield))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('After Tax Yield', style: subtitleStyle),
          trailing: _renderText(determineTextPercentageBasedOnChange(yieldModel.yieldAfterTax))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Total Owned', style: subtitleStyle),
          trailing: _renderText(compactText(yieldModel.cost))),
    ];
  }

  List<Widget> _rightColumn() {
    return [
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Tax Amount', style: subtitleStyle),
          trailing: _renderText(compactText(yieldModel.cost))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Yearly Dividend', style: subtitleStyle),
          trailing: _renderText(compactText(yieldModel.yearly))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Quarterly Dividend', style: subtitleStyle),
          trailing: _renderText(compactText(yieldModel.quarterly))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('monthly Dividend', style: subtitleStyle),
          trailing: _renderText(compactText(yieldModel.monthly))),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.only(top:8.0,left: 0.0,right: 0.0,bottom: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0x80212121),
            border: Border.all(width: 0.9, color:  kHintColor),
            boxShadow: [
              BoxShadow(
                color: const Color(0x66000000),
                offset: Offset(0, 0),
                blurRadius: 3,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(children: _leftColumn()),
              ),
              SizedBox(width: 40),
              Expanded(
                child: Column(children: _rightColumn()),
              )
            ],
          ),
        ),
        // Divider(),
        SizedBox(height: 30),
      ],
    );
  }
}
