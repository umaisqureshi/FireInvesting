import 'package:flutter/material.dart';

import 'package:MOT/helpers/color/color_helper.dart';
import 'package:MOT/helpers/text/text_helper.dart';

import 'package:MOT/models/profile/market_index.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/shared/styles.dart';

class PortfolioIndexWidget extends StatelessWidget {

  final MarketIndexModel index;

  PortfolioIndexWidget({
    @required this.index
  });

  static const _indexNameStyle = const TextStyle(
   fontWeight: FontWeight.bold,
   fontSize: 14
  );

  static const _indexPriceStyle = const TextStyle(
    fontSize: 12,
    color: kLightGray
  );

  static const _indexPriceChange = const TextStyle(
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: kSharpBorder,
            color: kBlueGray(900)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:4.0,left: 4.0),
              child: Text(index.name, style: _indexNameStyle, maxLines: 1,textAlign: TextAlign.left,),
            ),
            Padding(
              padding: const EdgeInsets.only(top:4.0,left: 4.0),
              child: Text(formatText(index.price), style: _indexPriceStyle),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: kSharpBorder,
                color: determineColorBasedOnChange(index.change)
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(determineTextBasedOnChange(index.change), style: _indexPriceChange,),
                  Text("(${determineTextPercentageBasedOnChange(index.changesPercentage)})", style: _indexPriceChange,),

                ],
              ),
            ),
          ]
        ),
      ),
      onPressed: () {},
    );
  }
}