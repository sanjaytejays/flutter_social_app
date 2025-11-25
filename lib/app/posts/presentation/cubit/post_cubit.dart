import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcon/app/posts/domain/models/post_model.dart';
import 'package:medcon/app/posts/domain/repo/post_repo.dart';
import 'package:medcon/app/posts/presentation/cubit/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  PostModel? postModel;
  PostCubit({required this.postRepo}) : super(PostInitial());

  Future<void> createPostCubit({required PostModel postModel}) async {
    try {
      emit(PostLoading());
      await postRepo.createPost(postModel: postModel);
      emit(PostCreated(postModel: postModel));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Stream<List<PostModel>> getPostsCubit() {
    try {
      emit(PostLoading());
      final posts = postRepo.getPosts();
      emit(PostLoaded(posts: posts));
      return posts;
    } catch (e) {
      emit(PostError(message: e.toString()));
      return Stream.empty();
    }
  }

  Future<void> votePollCubit({
    required String postId,
    required String optionId,
  }) async {
    try {
      emit(PostLoading());
      await postRepo.votePoll(postId: postId, optionId: optionId);
      emit(PostVoted(postId: postId, optionId: optionId));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
}
