import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOT/helpers/text/text_helper.dart';

import 'package:MOT/models/profile/stock_profile.dart';
import 'package:MOT/models/profile/stock_quote.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/profile/widgets/styles.dart';

class StatisticsWidget extends StatelessWidget {
  final StockQuote quote;
  final StockProfile profile;

  StatisticsWidget({@required this.quote, @required this.profile});

  static Text _renderText(dynamic text) {
    return text != null ? Text(compactText(text)) : Text('-');
  }

  List<Widget> _leftColumn() {
    return [
      ListTile(
          contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Open', style: subtitleStyle),
          trailing: _renderText(quote.open)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Prev close', style: subtitleStyle),
          trailing: _renderText(quote.previousClose)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Day High', style: subtitleStyle),
          trailing: _renderText(quote.dayHigh)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Day Low', style: subtitleStyle),
          trailing: _renderText(quote.dayLow)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('52 WK High', style: subtitleStyle),
          trailing: _renderText(quote.yearHigh)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('52 WK Low', style: subtitleStyle),
          trailing: _renderText(quote.dayLow)),
    ];
  }

  List<Widget> _rightColumn() {
    return [
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Outstanding Shares', style: subtitleStyle),
          trailing: _renderText(quote.sharesOutstanding)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Volume', style: subtitleStyle),
          trailing: _renderText(quote.volume)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Avg Vol', style: subtitleStyle),
          trailing: _renderText(quote.avgVolume)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('MKT Cap', style: subtitleStyle),
          trailing: _renderText(quote.marketCap)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('P/E Ratio', style: subtitleStyle),
          trailing: _renderText(quote.pe)),
      Divider(
        color: kHintColor,
        height: 1.0,
      ),
      ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('EPS', style: subtitleStyle),
          trailing: _renderText(quote.eps)),
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
            child: Text('Statistics', style: kProfileScreenSectionTitle)),
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
        ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('CEO', style: subtitleStyle),
          trailing: Text(displayDefaultTextIfNull(profile?.ceo??'-')),
        ),
        Divider(),

        ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Sector', style: subtitleStyle),
          trailing: Text(displayDefaultTextIfNull(profile?.sector??'-')),
        ),
        Divider(),

        ListTile(
           contentPadding: EdgeInsets.only(left: 5.0,right: 5.0),
          title: Text('Exchange', style: subtitleStyle),
          trailing: Text('${profile?.exchange??'-'}'),
        ),
        Divider(),

        Text('About ${profile?.companyName ?? '-'} ',
            style: kProfileScreenSectionTitle),
        SizedBox(height: 8),

        Text(
          profile?.description ?? '-',
          style: TextStyle(fontSize: 16, color: kLighterGray, height: 1.75),
        ),
        Divider(),

        SizedBox(height: 30),
      ],
    );
  }
}
