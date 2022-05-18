import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:MOT/bloc/login/login_bloc.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/login/login.dart';

import 'package:MOT/widgets/news/news.dart';
import 'package:MOT/widgets/register/register.dart';
import 'package:MOT/widgets/widgets/empty_screen.dart';
import 'package:MOT/widgets/widgets/standard/header.dart';

class RegisterSection extends StatelessWidget {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: kScaffoldBackground,
      body: OfflineBuilder(
        child: Container(),
        connectivityBuilder: ( context,  connectivity, child,  ) {
          return connectivity == ConnectivityResult.none 
          ? _buildNoConnectionMessage(context)
          : _buildContent(context);
        }
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
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [

            StandardHeader(
              title: 'Create a \nProfile!',
              subtitle: '',
              action: Container(),
            ),

            RegisterSectionWidget(globalKey:globalKey)
          ]
        ),
      )
    );
  }
}