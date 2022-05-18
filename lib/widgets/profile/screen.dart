import 'package:MOT/widgets/portfolio/widgets/heading/portfolio_heading.dart';
import 'package:MOT/widgets/widgets/standard/DrawerWidget.dart';
import 'package:MOT/widgets/widgets/standard/header.dart';
import 'package:flutter/material.dart';
import 'package:MOT/models/profile/profile.dart';
import 'package:MOT/models/storage/storage.dart';

import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/profile/widgets/profile/profile.dart';
import 'package:MOT/widgets/profile/widgets/widget/save_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {

  final bool isSaved;
  final Color color;
  final ProfileModel profile;

  ProfileScreen({
    @required this.isSaved,
    @required this.profile,
    @required this.color,
  });
 final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
          child: SafeArea(
          child:
              Profile(
                globalKey:globalKey,
                color: color,
                stockProfile: profile.stockProfile,
                stockChart: profile.stockChart,
                stockChart5Y: profile.stockChart5Y,
                stockChart1M: profile.stockChart1M,
                stockChart3M: profile.stockChart3M,
                stockChart6M: profile.stockChart6M,
                stockChart1D: profile.stockChart1D,
                stockChart5D: profile.stockChart5D,
                stockQuote: profile.stockQuote,
                isSaved: isSaved,

              ),
          // ProfileNewsScreen(news: profile.stockNews,),
      ),
        )
    );
  }
}