import 'package:MOT/helpers/text/text_helper.dart';
import 'package:MOT/models/dividend/DividendSP.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/profile/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividendResultWidget extends StatelessWidget {
  final DividendSP dividendSP;
  final int shareOwned;

  DividendResultWidget({@required this.dividendSP, @required this.shareOwned});

  static Text _renderText(dynamic text) {
    return text != null ? Text(text,) : Text('-');
  }

  List<Widget> _leftColumn() {
    return [
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Symbol', style: subtitleStyle),
          trailing: _renderText(dividendSP.dividendT.symbol)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Dividend Yield', style: subtitleStyle),
          trailing: _renderText(determineTextPercentageBasedOnChange(dividendSP.dividendS.dividendYield))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Prev Close', style: subtitleStyle),
          trailing: _renderText(determineTextBasedOnChange(dividendSP.dividendP.close))),
    ];
  }

  List<Widget> _rightColumn() {
    return [
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Shares Owned', style: subtitleStyle),
          trailing: _renderText(shareOwned.toString())),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Total Owned', style: subtitleStyle),
          trailing: _renderText(compactText(dividendSP.dividendP.close*shareOwned))),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Total Dividend', style: subtitleStyle),
          trailing: _renderText(compactText(((dividendSP.dividendP.close*shareOwned) *dividendSP.dividendS.dividendYield)/100))),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16),
        Align(
            alignment: Alignment.center,
            child: Text(dividendSP.dividendS.companyName, style: kProfileScreenSectionTitle)),
        SizedBox(height: 8),
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
