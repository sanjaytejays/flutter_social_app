import 'package:cloud_firestore/cloud_firestore.dart';

enum PostType { text, media, poll }

class PostModel {
  final String postId;
  final String authorUid;
  final String authorName;
  final String authorPic;
  final String postContent; // Text content
  final PostType postType;
  final DateTime postCreatedAt;

  // Engagement
  final int likesCount;
  final int commentsCount;
  final bool isLiked; // For UI state

  // Media Specific
  final List<String> mediaUrls; // Images or Video Thumbnail
  final bool isVideo;

  // Poll Specific
  final List<PollOption> pollOptions;
  final int totalPollVotes;
  final DateTime? pollExpiration;

  const PostModel({
    required this.postId,
    required this.authorUid,
    required this.postContent,
    required this.postType,
    required this.postCreatedAt,
    required this.authorName,
    required this.authorPic,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.mediaUrls = const [],
    this.isVideo = false,
    this.pollOptions = const [],
    this.totalPollVotes = 0,
    this.pollExpiration,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorName': authorName,
      'authorPic': authorPic,
      'authorId': authorUid,
      'content': postContent,
      'type': postType.toString().split('.').last,
      'createdAt': postCreatedAt,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'mediaUrls': mediaUrls,
      'isVideo': isVideo,
      'pollOptions': pollOptions.map((x) => x.toMap()).toList(),
      'totalPollVotes': totalPollVotes,
      'pollExpiration': pollExpiration != null
          ? Timestamp.fromDate(pollExpiration!)
          : null,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      authorName: map['authorName'] ?? 'Unknown',
      authorPic: map['authorPic'] ?? '',
      postId: id,
      authorUid: map['authorId'] ?? '',
      postContent: map['content'] ?? '',
      postType: PostType.values.firstWhere(
        (type) => type.toString().split('.').last == map['type'],
        orElse: () => PostType.text,
      ),
      postCreatedAt:
          (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      isVideo: map['isVideo'] ?? false,
      pollOptions: List<PollOption>.from(
        (map['pollOptions'] ?? []).map((x) => PollOption.fromMap(x)),
      ),
      totalPollVotes: map['totalPollVotes'] ?? 0,
      pollExpiration: (map['pollExpiration'] as Timestamp?)?.toDate(),
    );
  }
}

class PollOption {
  final String pollId;
  final String text;
  final int votes;

  PollOption({required this.pollId, required this.text, this.votes = 0});

  Map<String, dynamic> toMap() => {
    'pollId': pollId,
    'text': text,
    'votes': votes,
  };

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      pollId: map['pollId'] ?? '',
      text: map['text'] ?? '',
      votes: map['votes'] ?? 0,
    );
  }
}
