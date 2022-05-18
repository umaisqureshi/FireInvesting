import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:MOT/widgets/widgets/standard/header.dart';

class DividendHeadingSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  String title;
  String subtitle;
  bool showAction;
  Widget widget;
  DividendHeadingSection({this.globalKey, this.title, this.subtitle,this.showAction,this.widget});
  @override
  Widget build(BuildContext context) {

    final String formattedDate = DateFormat('MMMMd').format(DateTime.now());

    return StandardHeader(
      globalKey: globalKey,
      title: title??'Portfolio',
      subtitle: subtitle??formattedDate,
      action: showAction?GestureDetector(
        child: Icon(FontAwesomeIcons.user),
        onTap: () => Navigator.pushNamed(context, '/about')
      ):widget,
    );
  }
}