import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostRepository {
  // Singleton boilerplate
  PostRepository._();

  static PostRepository _instance = PostRepository._();
  static PostRepository get instance => _instance;

  // Instance
  final CollectionReference _postCollection = FirebaseFirestore.instance.collection('User');

  Stream<QuerySnapshot> getPosts() {
    return _postCollection.where("id", isNotEqualTo: FirebaseAuth.instance.currentUser.uid)
        .limit(5)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsPage(DocumentSnapshot lastDoc) {
    return _postCollection
        .startAfterDocument(lastDoc)
        .limit(5)
        .snapshots();
  }

  Stream<QuerySnapshot> getGuruPosts() {
    return _postCollection.where("id", isNotEqualTo: FirebaseAuth.instance.currentUser.uid)
    .where("type", isEqualTo: "guru")
        .limit(5)
        .snapshots();
  }

  Stream<QuerySnapshot> getGuruPostsPage(DocumentSnapshot lastDoc) {
    return _postCollection
        .startAfterDocument(lastDoc)
        .limit(5)
        .snapshots();
  }
}