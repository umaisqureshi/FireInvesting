import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MOT/shared/colors.dart';

class StandardHeader extends StatelessWidget {

  final String title;
  final String subtitle;
  final Widget action;
  final GlobalKey<ScaffoldState> globalKey;
  
  StandardHeader({
    @required this.title,
    @required this.subtitle,
    @required this.action,
    @required this.globalKey
  });

  static const kPortfolioHeaderTitle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold
  );

  static const kPortfolioSubtitle = const TextStyle(
    color: Colors.white54,
    fontSize: 20,
    fontWeight: FontWeight.w800
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:4.0),
          child: InkWell(onTap: (){
            this.globalKey.currentState.openDrawer();
          },child: Icon(FontAwesomeIcons.bars,color: kTextColor,)),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            children: [
              Text(this.title, style: kPortfolioHeaderTitle),
              Text(this.subtitle, style: kPortfolioSubtitle),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right:4.0),
          child: this.action,
        )
      ],
    );
  }
}