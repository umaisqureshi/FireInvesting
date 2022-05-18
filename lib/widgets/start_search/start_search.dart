import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/search/search_bloc.dart';
import 'package:MOT/bloc/start_search/start_search_bloc.dart';
import 'package:MOT/models/search/search.dart';
import 'package:MOT/models/start_search/StartSearch.dart';
import 'package:MOT/widgets/start_search/start_search_results/start_search_results.dart';
import 'package:MOT/widgets/widgets/loading_indicator.dart';
import 'package:MOT/widgets/widgets/message.dart';

class StartSearchScreenSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartSearchBloc, StartSearchState>(
        builder: (BuildContext context, StartSearchState state) {
      if (state is StartSearchInitial) {
        BlocProvider.of<StartSearchBloc>(context)
            .add(FetchStartSearchResults());
      }

      if (state is StartSearchResultsLoadingError) {
        return MessageScreen(message: state.message, action: Container());
      }
      if (state is FetchStartSearchData) {
        return _buildWrapperLimit(data: state.data);
      }

      if (state is FilterStartSearchData) {
        return _buildWrapper(data: state.data);
      }

      if (state is FetchFromCache) {
        return _buildWrapper(data: state.data);
      }

      if(state is StartSearchLoading){
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
          child: LoadingIndicatorWidget(),
        );
      }
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
        child: LoadingIndicatorWidget(),
      );
    });
  }

  Widget _buildWrapperLimit({List<StartStockSearch> data}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (BuildContext ctx, int i) {
          return StartSearchResultsWidget(search: data[i]);
        });
  }

  Widget _buildWrapper({List<StartStockSearch> data}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (BuildContext ctx, int i) {
          return StartSearchResultsWidget(search: data[i]);
        });
  }
}
