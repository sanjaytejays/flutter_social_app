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
      getAllPostsCubit();
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> deletePostCubit({required String postId}) async {
    try {
      await postRepo.deletePost(postId: postId);
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> getAllPostsCubit() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.getAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
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
