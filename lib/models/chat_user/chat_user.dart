import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String name;
  final String type;
  final String image;
  final String id;
  final String guruDescription;
  final String rating;

  const Post(this.name, this.type, this.image,this.id, this.guruDescription, this.rating);

  factory Post.fromSnapshot(Map data) {
    return Post(data['name'], data['type'], data['image'], data['id'], data['description'], data['rating']);
  }

  @override
  List<Object> get props => [name, type, image, id, guruDescription, rating];
}