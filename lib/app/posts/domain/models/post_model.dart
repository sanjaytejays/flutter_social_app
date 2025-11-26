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
    this.mediaUrls = const [],
    this.isVideo = false,
    this.pollOptions = const [],
    this.totalPollVotes = 0,
    this.pollExpiration,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorName': authorName,
      'postId': postId,
      'authorPic': authorPic,
      'authorId': authorUid,
      'content': postContent,
      'type': postType.toString().split('.').last,
      'createdAt': postCreatedAt,
      'mediaUrls': mediaUrls,
      'isVideo': isVideo,
      'pollOptions': pollOptions.map((x) => x.toMap()).toList(),
      'totalPollVotes': totalPollVotes,
      'pollExpiration': pollExpiration != null
          ? Timestamp.fromDate(pollExpiration!)
          : null,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      authorName: map['authorName'] ?? 'Unknown',
      authorPic: map['authorPic'] ?? '',
      postId: map['postId'] ?? '',
      authorUid: map['authorId'] ?? '',
      postContent: map['content'] ?? '',
      postType: PostType.values.firstWhere(
        (type) => type.toString().split('.').last == map['type'],
        orElse: () => PostType.text,
      ),
      postCreatedAt:
          (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
