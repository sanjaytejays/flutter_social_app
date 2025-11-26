import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medcon/app/posts/domain/models/post_model.dart';
import 'package:medcon/app/posts/domain/repo/post_repo.dart';

class ImplPostRepo implements PostRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // store the posts in a collection called 'posts'
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');
  @override
  Future<void> createPost({required PostModel postModel}) async {
    try {
      await postsCollection.doc(postModel.postId).set(postModel.toMap());
    } catch (e) {
      throw Exception("CREATE POST ERROR......$e");
    }
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      // get all posts from the 'posts' collection with most recent posts first
      final postSnapshot = await postsCollection
          .orderBy('createdAt', descending: true)
          .get();

      // convert each post document to a PostModel object(from json data to PostModel object)

      final List<PostModel> allPosts = postSnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // final posts = _firebaseFirestore
      //     .collection('posts')
      //     .orderBy('createdAt', descending: true)
      //     .snapshots()
      //     .map((snapshot) {
      //       return snapshot.docs
      //           .map((doc) => PostModel.fromMap(doc.data(), doc.id))
      //           .toList();
      //     });

      return allPosts;
    } catch (e) {
      throw Exception("GET POSTS ERROR......$e");
    }
  }

  @override
  Future<void> deletePost({required String postId}) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("DELETE POST ERROR......$e");
    }
  }

  @override
  Future<List<PostModel>> getPostByUserId({required String userId}) async {
    try {
      final postSnapshot = await postsCollection
          .where('userId', isEqualTo: userId)
          .get();

      final postsByUserId = postSnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return postsByUserId;
    } catch (e) {
      throw Exception("GET POST ERROR......$e");
    }
  }

  @override
  Future<void> votePoll({
    required String postId,
    required String optionId,
  }) async {
    try {
      final postRef = _firebaseFirestore.collection('posts').doc(postId);

      await _firebaseFirestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) throw Exception("Post does not exist");

        final post = PostModel.fromMap(snapshot.data()!);

        // Logic to increment specific poll option
        final updatedOptions = post.pollOptions.map((option) {
          if (option.pollId == optionId) {
            return PollOption(
              pollId: option.pollId,
              text: option.text,
              votes: option.votes + 1,
            );
          }
          return option;
        }).toList();

        transaction.update(postRef, {
          'pollOptions': updatedOptions.map((x) => x.toMap()).toList(),
          'totalPollVotes': post.totalPollVotes + 1,
        });
      });
    } catch (e) {
      throw Exception("VOTE POLL ERROR......$e");
    }
  }
}
