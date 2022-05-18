import 'package:MOT/bloc/dividend/dividend_bloc.dart';
import 'package:MOT/crypto_portfolio/tabs.dart';
import 'package:MOT/widgets/chat/chatAllGurus.dart';
import 'package:MOT/widgets/chat/chatHistory.dart';
import 'package:MOT/widgets/chat/guruChatHistory.dart';
import 'package:MOT/widgets/dividend/dividend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/loan_cal.dart';
import 'package:MOT/compund_cal.dart';

enum DrawerEnums{
  MY_PORTFOLIO,MY_PERFORMANCE,MY_DIVIDEND,PROJECTION,COMMUNITY,GURU
}
class DrawerWidget extends StatefulWidget {
  final ValueChanged onClickDrawer;
  const DrawerWidget({Key key, this.onClickDrawer}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: <Widget>[
            ListTile(
              onTap: () {
              },
              leading: Icon(
                FontAwesomeIcons.bars,
                color: kTextColor,
              ),
            ),
            ListTile(
              onTap: () {
              },
              leading: Icon(
                FontAwesomeIcons.briefcase,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'My Portfolio',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
              },
              leading: Icon(
                FontAwesomeIcons.tachometerAlt,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
               'MY Performance',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
                BlocProvider.of<DividendBloc>(context).add(FetchFromLocal());
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => DividendSection(showFloatingButton: true,)));
              },
              leading: Icon(
                IconDataSolid(0xf080),
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'My Dividend',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
              },
              leading: Icon(
                FontAwesomeIcons.chartLine,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
               'Projection',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return ChatHistoryCommunityScreen();
                  }
                ));
              },
              leading: Icon(
                FontAwesomeIcons.handshake,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Community',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return AllGuruChatScreen();
                    }
                ));
              },
              leading: Icon(
                FontAwesomeIcons.userTie,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Guru',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            Divider(
              color: Theme.of(context).hintColor,
              height: 2.0,
              indent: 8,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return LoanCalculator();
                    }
                ));
              },
              leading: Icon(
                IconDataSolid(0xf111),
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'My Real Estate',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Tabs();
                }));
              },
              leading: Icon(
                IconDataSolid(0xf111),
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'My Crypto',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => DividendSection(showFloatingButton: false,)));
              },
              leading: Icon(
                IconDataSolid(0xf111),
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Dividend Calculator',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CompoundCalculator();
                }));
              },
              leading: Icon(
                IconDataSolid(0xf111),
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Compound Calculator',
                style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
