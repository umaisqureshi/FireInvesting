import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'package:MOT/bloc/sector_performance/sector_performance_bloc.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/markets/markets_performance.dart';
import 'package:MOT/widgets/widgets/empty_screen.dart';
import 'package:MOT/widgets/widgets/standard/header.dart';

class MarketsSection extends StatelessWidget {
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
    return RefreshIndicator(
      child: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            StandardHeader(
              title: 'U.S Markets',
              subtitle: 'Sector Performance',
              action: Container(),
              globalKey: globalKey,
            ),
            MarketsPerformance()
          ]
        )
      ),
      onRefresh: () async {
        // Reload markets section.
        BlocProvider
        .of<SectorPerformanceBloc>(context)
        .add(FetchSectorPerformance());
      },
    );
  }
}

