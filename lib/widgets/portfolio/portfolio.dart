import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:MOT/widgets/widgets/standard/DrawerWidget.dart';
import 'package:MOT/bloc/portfolio/portfolio_bloc.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/portfolio/portfolio_stonks.dart';

import 'package:MOT/widgets/portfolio/widgets/heading/portfolio_heading.dart';
import 'package:MOT/widgets/widgets/empty_screen.dart';

class PortfolioSection extends StatelessWidget {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
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
        child: OfflineBuilder(
          child: Container(),
          connectivityBuilder: ( context,  connectivity, child,  ) {
            return connectivity == ConnectivityResult.none
            ? _buildNoConnectionMessage(context)
            : _buildContent(context);
          }
        ),
      )
    );
  }

  Widget _buildNoConnectionMessage(context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 14,
        left: 24,
        right: 24
      ),
      child: EmptyScreen(message: 'Looks like you don\'t have an internet connection.'),
    );
  }

  Widget _buildContent(context) {
    return RefreshIndicator(
      child: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          children: [
            PortfolioHeadingSection(globalKey:globalKey,showAction: true,title: null,subtitle: null,),
            SizedBox(height: 10,),
            PortfolioStonksSection()
          ]
        )
      ),

      onRefresh: () async {
        // Reload stocks section.
        BlocProvider
        .of<PortfolioBloc>(context)
        .add(FetchPortfolioData());
      },
    );
  }

}