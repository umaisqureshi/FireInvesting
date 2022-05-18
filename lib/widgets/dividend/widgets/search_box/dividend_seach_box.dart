import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/widgets/StepperTouch.dart';
import 'package:flutter/material.dart';

class DividendSearchBoxWidget extends StatelessWidget {
  final ValueChanged<String> onChangeSymbol;
  final ValueChanged<int> onChangeShare;
  final Animation<double> offsetAnimation;
  final double horizontalPadding = 5;
  final double animationRange = 5;

  DividendSearchBoxWidget(
      {this.onChangeSymbol, this.onChangeShare, this.offsetAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: offsetAnimation,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: animationRange),
            padding: EdgeInsets.only(
                left: offsetAnimation.value + horizontalPadding,
                right: horizontalPadding - offsetAnimation.value),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                    height: 120,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Stock Symbol",
                                  style: TextStyle(fontSize: 15.5),
                                ),
                                Text(
                                  "Your Shares Owned",
                                  style: TextStyle(fontSize: 15.5),
                                )
                              ]),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.search),
                                SizedBox(width: 8),
                                Expanded(
                                    child: TextFormField(
                                        textAlign: TextAlign.start,
                                        decoration: InputDecoration(
                                          hintText: 'Symbol  (eg: aapl)',
                                          hintStyle: TextStyle(fontSize: 15.5),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          if (value.length >= 2) {
                                            onChangeSymbol(value);
                                          }
                                        })),
                                StepperTouch(
                                  counterColor: kTextColor,
                                  onChanged: (value) {
                                    onChangeShare(value);
                                  },
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )),
              ],
            ),
          );
        }
    );
  }
}
