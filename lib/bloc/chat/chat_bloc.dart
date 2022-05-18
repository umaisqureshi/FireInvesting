import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/models/chat_user/chat_user.dart';
import 'package:MOT/respository/chat/supplemental.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<DataEvent, DataState> {
  ChatBloc();

  List<StreamSubscription> subscriptions = [];
  List<List<Post>> posts = [];
  bool hasMoreData = true;
  bool isListEmpty = false;
  DocumentSnapshot lastDoc;

  // We use this function to handle events from our streams
  handleStreamEvent(int index, QuerySnapshot snap, isGuru) {
    // We request 15 docs at a time
    if (snap.docs.length < 5) {
      hasMoreData = false;
    }

    // If the snapshot is empty, there's nothing for us to do
    if (snap.docs.isEmpty) {
      isListEmpty = true;
    }

    if (index == posts.length) {
      // Set the last document we pulled to use as a cursor
      if(snap.docs.isEmpty){
        return;
      }
      lastDoc = snap.docs[snap.docs.length - 1];
    }
    // Turn the QuerySnapshot into a List of posts
    List<Post> newList = [];

    var list =  isGuru ? snap.docs.where((element) => element.data()["id"]!=FirebaseAuth.instance.currentUser.uid && element.data()['type']!='investor'): snap.docs.where((element) => element.data()["id"]!=FirebaseAuth.instance.currentUser.uid && element.data()['type']!='guru');

   list.forEach((element) {
     newList.add(Post.fromSnapshot(element.data()));
   });
    /*snap.docs.forEach((doc) {
      // This is a good spot to filter your data if you're not able
      // to compose the query you want.
      if(doc.data()["id"]==FirebaseAuth.instance.currentUser.uid){

      }else{
        newList.add(Post.fromSnapshot(doc.data()));
      }
    });*/
    // Update the posts list
    if (posts.length <= index) {
      posts.add(newList);
    } else {
      posts[index].clear();
      posts[index] = newList;
    }
    isGuru ? add(GuruEventLoad(posts)): add(DataEventLoad(posts));
  }

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is DataEventStart) {
      // Clean up our variables
      hasMoreData = true;
      lastDoc = null;
      subscriptions.forEach((sub) {
        sub.cancel();
      });
      posts.clear();
      subscriptions.clear();
      subscriptions.add(
          PostRepository.instance.getPosts().listen((event) {
            handleStreamEvent(0, event, false);
          })
      );
      add(DataEventLoad(posts));
    }

    if (event is DataEventLoad) {
      // Flatten the posts list
      final elements = posts.expand((i) => i).toList();

      if (elements.isEmpty) {
        yield DataStateEmpty();
      } else {
        yield DataStateLoadSuccess(elements, hasMoreData);
      }
    }

    if (event is DataEventFetchMore) {
      if (lastDoc == null) {
        throw Exception("Last doc is not set");
      }
      final index = posts.length;
      subscriptions.add(
          PostRepository.instance.getPostsPage(lastDoc).listen((event) {
            handleStreamEvent(index, event, false);
          })
      );
    }

    if(event is GuruEventStart){
      hasMoreData = true;
      lastDoc = null;
      subscriptions.forEach((sub) {
        sub.cancel();
      });
      posts.clear();
      subscriptions.clear();
      subscriptions.add(
          PostRepository.instance.getGuruPosts().listen((event) {
            handleStreamEvent(0, event, true);
          })
      );
      add(GuruEventLoad(posts));
    }

    if(event is GuruEventLoad){
      final elements = posts.expand((i) => i).toList();

      if (elements.isEmpty) {
        yield GuruStateEmpty();
      } else {
        yield GuruStateLoadSuccess(elements, hasMoreData);
      }
    }

    if(event is GuruEventFetchMore){
      if (lastDoc == null) {
        throw Exception("Last doc is not set");
      }
      final index = posts.length;
      subscriptions.add(
          PostRepository.instance.getGuruPostsPage(lastDoc).listen((event) {
            handleStreamEvent(index, event, true);
          })
      );
    }

  }

  @override
  onChange(change) {
    print(change);
  }

  @override
  Future<void> close() async {
    subscriptions.forEach((s) => s.cancel());
    super.close();
  }

  @override
  // TODO: implement initialState
  DataState get initialState => DataStateInitial();
}