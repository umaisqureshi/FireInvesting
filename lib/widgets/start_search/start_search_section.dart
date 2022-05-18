
import 'package:flutter/material.dart';
import 'package:MOT/widgets/search/search.dart';
import 'package:MOT/widgets/search/search_box/seach_box.dart';
import 'package:MOT/widgets/start_search/start_search.dart';
import 'package:MOT/widgets/start_search/start_search_box/start_seach_box.dart';
import 'package:MOT/widgets/widgets/base_list.dart';
import 'package:MOT/widgets/widgets/standard/header.dart';

class StartSearchSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseList(
      globalKey: globalKey,
      children: [
        StandardHeader(
          title: 'Search',
          subtitle: 'Search Companies',
          action: Container(),
          globalKey: globalKey,
        ),

        // Search Box.
        SizedBox(height: 16),
        StartSearchBoxWidget(),
        SizedBox(height: 16),
        StartSearchScreenSection()
      ]
    );
  }
}