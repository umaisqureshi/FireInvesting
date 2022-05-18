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
  final bool showFloatingButton;
  DividendSection({this.showFloatingButton});
  @override
  _DividendSectionState createState() => _DividendSectionState();
}

class _DividendSectionState extends State<DividendSection> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool sheetOpen = false;
  bool withSymbol = false;
  final Duration animationDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 300);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;
  void _onTap() async{
    if(rect!=null){
      _goToNextPage();
      return;
    }
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));  //<-- set rect to be size of fab
    WidgetsBinding.instance.addPostFrameCallback((_) {                //<-- on the next frame...
      setState(() =>
      rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide)); //<-- set rect to be big
    //  Future.delayed(animationDuration + delay, _goToNextPage); //<-- after delay, go to next page
    });
  }
  void _goToNextPage() {
    setState(() => rect = null);
  }
  Widget _ripple() {
    return rect==null?Container():Positioned(
      left: rect.left,                                          //<-- Margin from left
      right: MediaQuery.of(context).size.width - rect.right,    //<-- Margin from right
      top: rect.top,                                            //<-- Margin from top
      bottom: MediaQuery.of(context).size.height - rect.bottom, //<-- Margin from bottom
      child: Container(                                         //<-- Blue cirle
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
    );
  }

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
          floatingActionButton: widget.showFloatingButton?sheetOpen
              ? new FloatingActionButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close),
                  foregroundColor: Theme.of(context).iconTheme.color,
                  backgroundColor: Theme.of(context).accentIconTheme.color,
                  elevation: 4.0,
                  tooltip: "Close",
                )
              : new FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      sheetOpen = true;
                    });
                    globalKey.currentState
                        .showBottomSheet((BuildContext context) {
                          return new TransactionDividend();})
                        .closed
                        .whenComplete(() {
                          setState(() {
                            sheetOpen = false;
                          });
                        });},
                  icon: Icon(Icons.add),
                  label: new Text("Add"),
                  foregroundColor: Theme.of(context).iconTheme.color,
                  backgroundColor: kTextColor,
                  elevation: 4.0,
                  tooltip: "Add",
                ):null,
        /*  RectGetter(           //<-- Wrap Fab with RectGetter
            key: rectGetterKey,                       //<-- Passing the key
            child: FloatingActionButton(
              onPressed: _onTap,
              child: Icon(Icons.mail_outline),
            ),
          ),*/
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
            child: OfflineBuilder(
                child: Container(),
                connectivityBuilder: (
                  context,
                  connectivity,
                  child,
                ) {
                  return connectivity == ConnectivityResult.none
                      ? _buildNoConnectionMessage(context)
                      : _buildContent(context);
                }),
          )),
    );
  }

  Widget _buildNoConnectionMessage(context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 14, left: 24, right: 24),
      child: EmptyScreen(
          message: 'Looks like you don\'t have an internet connection.'),
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
                subtitle: !widget.showFloatingButton?"Calculator":"Portfolio",
                widget: Container(
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(
                height: 10,
              ),
                  !widget.showFloatingButton?DividendCalculator(withSymbol: withSymbol,):DividendPortfolio(),
            ]),
           /* _ripple()*/

          ],
        ));
  }
}
