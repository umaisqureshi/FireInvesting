import 'package:MOT/chat/chat.dart';
import 'package:MOT/chat/repo/route_argument.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/chat/chatAllUsers.dart';
import 'package:MOT/widgets/portfolio/widgets/heading/portfolio_heading.dart';
import 'package:MOT/widgets/widgets/standard/DrawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/chat/chat_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryCommunityScreen extends StatefulWidget {
  @override
  createState() => _ChatHistoryCommunityScreenState();
}

class _ChatHistoryCommunityScreenState
    extends State<ChatHistoryCommunityScreen> {
  //ChatBloc _chatBloc = ChatBloc();
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<QueryDocumentSnapshot> chatHistory = [];
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();


  @override
  initState() {
    super.initState();
    //_chatBloc.add(DataEventStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
    /*  appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Community',
          style: TextStyle(color: Colors.lightGreen),
        ),
      ),*/
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return LazyListScreen();
          }));
        },
        child: Icon(Icons.chat_bubble, color: kScaffoldBackground,),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              children: [
                PortfolioHeadingSection(globalKey:globalKey,showAction: false,title: "Community",subtitle: '',widget: Container(width: 20,),),
                SizedBox(height: 10,),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('User').where("type", isEqualTo: "investor")
                        .where('chattedWith', arrayContains: _auth.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        chatHistory = snapshot.data.docs;
                        int length = snapshot.data.docs.length;
                        return ListView.separated(
                          shrinkWrap: true,
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            itemCount: length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: ()async{
                                  User user = FirebaseAuth.instance.currentUser;
                                  String userId = await FirebaseAuth.instance.currentUser.uid;
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.setString('id', userId);
                                  DocumentSnapshot doc = await FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(chatHistory[index].data()['id'])
                                      .get();
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return Chat(routeArgument: RouteArgument(
                                        param1: doc['id'],
                                        param2: doc['image'] ?? 'default',
                                        param3: doc['email'] ?? 'User'));
                                  }));
                                },
                                title: Text(chatHistory[index].data()['name']),
                                subtitle: Text(chatHistory[index].data()['lastMessage'] ?? ""),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white70,
                                  backgroundImage:
                                  chatHistory[index].data()['image'] != null
                                      ? NetworkImage(
                                    "${chatHistory[index].data()['image']}",
                                  )
                                      : AssetImage(
                                    "assets/images/avatar.png",
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            });
                      } else
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.green,
                            strokeWidth: 2,
                          ),
                        );
                    }),
              ],

          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //_chatBloc.close();
    super.dispose();
  }
}
