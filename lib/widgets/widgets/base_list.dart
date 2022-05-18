import 'package:flutter/material.dart';
import 'package:MOT/shared/colors.dart';

class BaseList extends StatelessWidget {

  final List<Widget> children;
  final GlobalKey<ScaffoldState> globalKey;

  BaseList({
    @required this.children,
    @ required this.globalKey
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: kScaffoldBackground,
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: this.children
        )
      )
    );
  }
}