import 'package:medcon/app/posts/domain/models/post_model.dart';

abstract class PostRepo {
  // Create Post
  Future<void> createPost({required PostModel postModel});
  // Fetch all posts
  Future<List<PostModel>> getAllPosts();
  // Vote on a poll
  Future<void> votePoll({required String postId, required String optionId});

  Future<void> deletePost({required String postId});

  Future<void> getPostByUserId({required String userId});
}
