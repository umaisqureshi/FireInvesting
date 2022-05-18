import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/profile/profile_bloc.dart';
import 'package:MOT/models/markets/market_active/market_active.dart';
import 'package:MOT/shared/styles.dart';
import 'package:MOT/widgets/profile/profile.dart';

class MarketMovers extends StatelessWidget {

  final MarketActiveModel data;
  final Color color;

  MarketMovers({
    @required this.data,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14),
      child: Container(
        child: _buildContent(context),
        width: 100,
        decoration: BoxDecoration(
          borderRadius: kStandatBorder,
          color: color,
        ),
      )
    );
  }

  Widget _buildContent(BuildContext context) {
    return GestureDetector(
      
      onTap: () {
        // Trigger fetch event.
        BlocProvider
          .of<ProfileBloc>(context)
          .add(FetchProfileData(symbol: data.symbol));

        // Send to Profile.
        Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(symbol: data.symbol)));
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // Ticker Symbol.
          Text(data.symbol, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.5
          )),

          // Change percentage.
          SizedBox(height: 5),
          Text(data.changesPercentage),
        ],
      ),
    );
  }
}