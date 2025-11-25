import 'package:medcon/app/posts/domain/models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final Stream<List<PostModel>> posts;
  PostLoaded({required this.posts});
}

class PostCreated extends PostState {
  final PostModel postModel;
  PostCreated({required this.postModel});
}

class PostVoted extends PostState {
  final String postId;
  final String optionId;
  PostVoted({required this.postId, required this.optionId});
}

class PostError extends PostState {
  final String message;
  PostError({required this.message});
}
