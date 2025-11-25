import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcon/app/posts/presentation/cubit/post_cubit.dart';
import '../../domain/models/post_model.dart';
import '../components/post_card.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

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
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: context.read<PostCubit>().getPostsCubit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show some empty state or mock data for preview
            return _buildMockFeed(context);
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: posts[index],
                onVote: (optionId) => context.read<PostCubit>().votePollCubit(
                  postId: posts[index].postId,
                  optionId: optionId,
                ),
              );
            },
          );
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

  Widget _buildMockFeed(BuildContext context) {
    // Provides immediate visual feedback if Firestore is empty
    final mockPosts = [
      PostModel(
        postId: '1',
        authorUid: '1',
        authorName: 'Dr. Emily Chen',
        authorPic: 'https://ui-avatars.com/api/?name=Emily+Chen',
        postContent:
            'Does anyone have experience with the new guidelines for pediatric asthma management? The changes regarding biologics seem significant.',
        postType: PostType.text,
        postCreatedAt: DateTime.now(),
        commentsCount: 5,
        likesCount: 12,
      ),
      PostModel(
        postId: '2',
        authorUid: '2',
        authorName: 'Dr. James Wilson',
        authorPic: 'https://ui-avatars.com/api/?name=James+Wilson',
        postContent:
            'Which treatment do you prefer for first-line therapy in acute migraine?',
        postType: PostType.poll,
        postCreatedAt: DateTime.now(),
        totalPollVotes: 100,
        pollOptions: [
          PollOption(pollId: 'a', text: 'Triptans', votes: 60),
          PollOption(pollId: 'b', text: 'NSAIDs', votes: 30),
          PollOption(pollId: 'c', text: 'Anti-emetics', votes: 10),
        ],
      ),
    ];

    return ListView.builder(
      itemCount: mockPosts.length,
      itemBuilder: (context, index) => PostCard(post: mockPosts[index]),
    );
  }
}
