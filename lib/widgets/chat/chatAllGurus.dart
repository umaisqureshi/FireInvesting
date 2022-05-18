import 'package:MOT/chat/chat.dart';
import 'package:MOT/chat/repo/route_argument.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/portfolio/widgets/heading/portfolio_heading.dart';
import 'package:MOT/widgets/widgets/standard/DrawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/chat/chat_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_dialog/rating_dialog.dart';

class AllGuruChatScreen extends StatefulWidget {
  @override
  createState() => _AllGuruChatScreenState();
}

class _AllGuruChatScreenState extends State<AllGuruChatScreen> {
  ChatBloc _chatBloc = ChatBloc();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _chatBloc.add(GuruEventStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      /*appBar: AppBar(
        centerTitle: true,
        title: Text(
          'We Are Here To Help',
          style: TextStyle(color: Colors.lightGreen[300]),
        ),
      ),*/
      drawer: DrawerWidget(),
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
              PortfolioHeadingSection(
                globalKey: globalKey,
                showAction: false,
                title: "We are here to help you",
                subtitle: '',
                widget: Container(
                  width: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<ChatBloc, DataState>(
                  bloc: _chatBloc,
                  // ignore: missing_return
                  builder: (BuildContext context, DataState state) {
                    if (state is GuruStateLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is GuruStateEmpty) {
                      return Center(
                        child: Text(
                          'No Posts',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      );
                    } else if (state is GuruStateLoadSuccess) {
                      return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          itemCount: state.hasMoreData
                              ? state.posts.length + 1
                              : state.posts.length,
                          itemBuilder: (context, i) {
                            if (i >= state.posts.length) {
                              _chatBloc.add(GuruEventFetchMore());
                              return _chatBloc.isListEmpty
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.only(top: 15),
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                            }
                            return ListTile(
                              title: Text(
                                state.posts[i].name,
                                style: TextStyle(color: Colors.red),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            double.parse(state.posts[i].rating) ?? 0.0,
                                        itemSize: 20,
                                        minRating: 1,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 10,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      Text(
                                        "${state.posts[i].rating ?? 0.0}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(state.posts[i].guruDescription ??
                                      "Laoshe Maoshe")
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () async {

                                  User user = FirebaseAuth.instance.currentUser;
                                  String userId = await FirebaseAuth
                                      .instance.currentUser.uid;
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.setString('id', userId);

                                  DocumentSnapshot doc = await FirebaseFirestore
                                      .instance
                                      .collection('User')
                                      .doc(state.posts[i].id)
                                      .get();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Chat(
                                            routeArgument: RouteArgument(
                                                param1: doc['id'],
                                                param2: doc['image'] ?? 'default',
                                                param3: doc['email'] ?? 'User'));
                                      })).then((value) {
                                    FirebaseFirestore.instance.collection('User').doc(state.posts[i].id).set(
                                        {
                                          userId: false
                                        }, SetOptions(merge: true));
                                    /*showDialog(
                                        context: context,
                                        builder: (context){
                                          return RatingDialog(
                                            // your app's name?
                                            title: 'Rating Dialog',
                                            // encourage your user to leave a high rating?
                                            description:
                                            'Tap a star to set your rating. Add more description here if you want.',
                                            // your app's logo?
                                            //image: const FlutterLogo(size: 100),
                                            submitButton: 'Submit',

                                            onSubmitPressed: (response) {
                                              print('rating: ${response.rating}, comment: ${response.comment}');

                                              FirebaseFirestore.instance.collection("User").doc(state.posts[i].id).set({
                                                'rating' : response.rating.toString()
                                              }, SetOptions(merge: true));


                                              // TODO: add your own logic
                                              if (response.rating < 3.0) {
                                                // send their comments to your email or anywhere you wish
                                                // ask the user to contact you instead of leaving a bad review
                                              } else {

                                              }
                                            },
                                          );
                                        }
                                    );*/
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Ask Me",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )),
                                ),
                              ),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }
}
