import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/dividend/dividend_calculator.dart';
import 'package:MOT/widgets/dividend/dividend_portfolio.dart';
import 'package:MOT/widgets/dividend/widgets/heading/dividend_heading.dart';
import 'package:MOT/widgets/dividend/widgets/transaction_dividend.dart';
import 'package:MOT/widgets/widgets/empty_screen.dart';
import 'package:MOT/widgets/widgets/standard/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:rect_getter/rect_getter.dart';

class DividendSection extends StatefulWidget {

  @override
  _DividendSectionState createState() => _DividendSectionState();
}

class _DividendSectionState extends State<DividendSection> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
          key: globalKey,
          backgroundColor: kScaffoldBackground,
          drawer: DrawerWidget(),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/background.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: _buildContent(context),
          )),
    );
  }

  Widget _buildContent(context) {
    return SafeArea(
        child: Stack(
          children: [
            ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                children: [
              DividendHeadingSection(
                globalKey: globalKey,
                showAction: false,
                title: "Dividend",
                subtitle: "",
                widget: Container(
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
           /* _ripple()*/

          ],
        ));
  }
}
