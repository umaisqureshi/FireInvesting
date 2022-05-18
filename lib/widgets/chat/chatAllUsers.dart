import 'package:MOT/chat/chat.dart';
import 'package:MOT/chat/repo/route_argument.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/widgets/standard/DrawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/chat/chat_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LazyListScreen extends StatefulWidget {
  @override
  createState() => _LazyListScreenState();
}

class _LazyListScreenState extends State<LazyListScreen> {
  ChatBloc _chatBloc = ChatBloc();

  @override
  initState() {
    super.initState();
    _chatBloc.add(DataEventStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Community',
          style: TextStyle(color: Colors.lightGreen[300]),
        ),
      ),
      drawer: DrawerWidget(),
      body: BlocBuilder<ChatBloc, DataState>(
          bloc: _chatBloc,
          // ignore: missing_return
          builder: (BuildContext context, DataState state) {
            if (state is DataStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataStateEmpty) {
              return Center(
                child: Text(
                  'No Posts',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            } else if (state is DataStateLoadSuccess) {
              return ListView.separated(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  itemCount: state.hasMoreData
                      ? state.posts.length + 1
                      : state.posts.length,
                  itemBuilder: (context, i) {
                    if (i >= state.posts.length) {
                      _chatBloc.add(DataEventFetchMore());
                      return _chatBloc.isListEmpty
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 30,
                              width: 30,
                              child: Center(child: CircularProgressIndicator()),
                            );
                    }
                    return ListTile(
                      onTap: ()async{
                        User user = FirebaseAuth.instance.currentUser;
                        String userId = await FirebaseAuth.instance.currentUser.uid;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('id', userId);
                        DocumentSnapshot doc = await FirebaseFirestore.instance
                            .collection('User')
                            .doc(state.posts[i].id)
                            .get();
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Chat(routeArgument: RouteArgument(
                              param1: doc['id'],
                              param2: doc['image'] ?? 'default',
                              param3: doc['email'] ?? 'User'));
                        }));
                       /* Navigator.of(context).pushNamed('/chat',
                            arguments: RouteArgument(
                                param1: doc['id'],
                                param2: doc['image'] ?? 'default',
                                param3: doc['email'] ?? 'User'));*/
                      },
                      title: Text(state.posts[i].name),
                      subtitle: Text(state.posts[i].type ?? ""),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white70,
                        backgroundImage: state.posts[i].image != null
                            ? NetworkImage(
                                "${state.posts[i].image}",
                              )
                            : AssetImage(
                                "assets/images/avatar.png",
                              ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return Divider();
                  });
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }
}
