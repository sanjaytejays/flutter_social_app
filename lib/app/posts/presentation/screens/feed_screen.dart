import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcon/app/authentication/domain/model/user_model.dart';
import 'package:medcon/app/authentication/presentation/cubits/auth_cubit.dart';
import 'package:medcon/app/posts/presentation/cubit/post_cubit.dart';
import 'package:medcon/app/posts/presentation/cubit/post_state.dart';
import '../../domain/models/post_model.dart';
import '../components/post_card.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final postCubit = context.read<PostCubit>();

  // on start get all posts
  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  // get all posts
  void getAllPosts() async => postCubit.getAllPostsCubit();

  // delete post
  void deletePost(String postId) async {
    postCubit.deletePostCubit(postId: postId);
    getAllPosts();
  }

  // Vote on poll
  void votePoll(String postId, String optionId) async {
    postCubit.votePollCubit(postId: postId, optionId: optionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.person_outline),
        ),
        centerTitle: true,
        title: Text('Medcon'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getAllPosts();
              });
            },
            icon: Icon(Icons.refresh_outlined),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading || state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return const Center(child: Text('No posts yet'));
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: allPosts[index],
                  onVote: (optionId) =>
                      votePoll(allPosts[index].postId, optionId),
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Something went wrong'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
