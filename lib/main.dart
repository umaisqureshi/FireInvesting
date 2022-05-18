import 'package:MOT/bloc/chat/chat_bloc.dart';
import 'package:MOT/bloc/dividend/dividend_bloc.dart';
import 'package:MOT/crypto_portfolio/repo/portfolio_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:MOT/bloc/login/login_bloc.dart';
import 'package:MOT/bloc/news/news_bloc.dart';
import 'package:MOT/bloc/portfolio/portfolio_bloc.dart';
import 'package:MOT/bloc/profile/profile_bloc.dart';
import 'package:MOT/bloc/search/search_bloc.dart';
import 'package:MOT/bloc/sector_performance/sector_performance_bloc.dart';
import 'package:MOT/widgets/about/about.dart';
import 'package:MOT/widgets/splash/splash_screen.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/register/register_bloc.dart';
import 'bloc/start_search/start_search_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getAppDocDir();
  runApp(MultiProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider<StartSearchBloc>(
          create: (context) => StartSearchBloc(),
        ),
        BlocProvider<PortfolioBloc>(
          create: (context) => PortfolioBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<DividendBloc>(
          create: (context) => DividendBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
        BlocProvider<SectorPerformanceBloc>(
          create: (context) => SectorPerformanceBloc(),
        ),
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Stock Market App',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Color(0xff3dc10e),
          hintColor: Color(0xffd6ffc8),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {'/about': (context) => AboutSection()},
      )));
}
