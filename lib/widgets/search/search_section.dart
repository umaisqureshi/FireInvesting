import 'package:flutter/material.dart';
import 'package:MOT/widgets/search/search.dart';
import 'package:MOT/widgets/search/search_box/seach_box.dart';
import 'package:MOT/widgets/start_search/start_search_box/start_seach_box.dart';
import 'package:MOT/widgets/widgets/base_list.dart';
import 'package:MOT/widgets/widgets/standard/header.dart';

class SearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseList(
      children: [
        StandardHeader(
          title: 'Search',
          subtitle: 'Search Companies',
          action: Container(),
        ),

        // Search Box.
        SizedBox(height: 16),
        SearchBoxWidget(),
        SizedBox(height: 16),
        SearchScreenSection()
      ]
    );
  }
}