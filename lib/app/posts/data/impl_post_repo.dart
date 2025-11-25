import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medcon/app/posts/domain/models/post_model.dart';
import 'package:medcon/app/posts/domain/repo/post_repo.dart';

class ImplPostRepo implements PostRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<void> createPost({required PostModel postModel}) async {
    try {
      await _firebaseFirestore.collection("posts").add(postModel.toMap());
    } catch (e) {
      throw Exception("CREATE POST ERROR......$e");
    }
  }

  @override
  Stream<List<PostModel>> getPosts() {
    try {
      final posts = _firebaseFirestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => PostModel.fromMap(doc.data(), doc.id))
                .toList();
          });

      return posts;
    } catch (e) {
      throw Exception("GET POSTS ERROR......$e");
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

        final post = PostModel.fromMap(snapshot.data()!, snapshot.id);

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
