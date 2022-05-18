import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/widgets/StepperTouch.dart';
import 'package:flutter/material.dart';

class GeneralDividendSearchBoxWidget extends StatelessWidget {
  final ValueChanged<double> dividendPerShare;
  final ValueChanged<double> costPerShare;
  final ValueChanged<int> numOfShare;
  final ValueChanged<double> taxPercent;
  GeneralDividendSearchBoxWidget(
      {this.dividendPerShare, this.costPerShare,this.numOfShare,this.taxPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 10),
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          TextFormField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Dividend per Share',
                hintStyle: TextStyle(fontSize: 15.5),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
              ),
              onChanged: (value) {
                dividendPerShare(double.parse(value));
              }),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Cost per Share',
                hintStyle: TextStyle(fontSize: 15.5),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
              ),
              onChanged: (value) {
                costPerShare(double.parse(value));
              }),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Number of Share',
                hintStyle: TextStyle(fontSize: 15.5),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
              ),
              onChanged: (value) {
                numOfShare(int.parse(value));
              }),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Tax Percent %',
                hintStyle: TextStyle(fontSize: 15.5),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: kTextColor)),
              ),
              onChanged: (value) {
                taxPercent(double.parse(value));
              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
