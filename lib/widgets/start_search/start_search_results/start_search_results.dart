
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/profile/profile_bloc.dart';
import 'package:MOT/bloc/search/search_bloc.dart';
import 'package:MOT/models/search/search.dart';
import 'package:MOT/models/start_search/StartSearch.dart';
import 'package:MOT/widgets/profile/profile.dart';

class StartSearchResultsWidget extends StatelessWidget {

  final StartStockSearch search;

  StartSearchResultsWidget({
    @required this.search
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(search.symbol),
      onTap: () {
        Navigator
        .push(context, MaterialPageRoute(builder: (_) => Profile( symbol: search.symbol)));

        BlocProvider
        .of<ProfileBloc>(context)
        .add(FetchProfileData(symbol: search.symbol));
      },
    );
  }
}