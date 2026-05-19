// ───────────────── USER MODEL ─────────────────

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final double rating;
  final int totalSwaps;
  final String bio;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage = '',
    this.skillsOffered = const [],
    this.skillsWanted = const [],
    this.rating = 0.0,
    this.totalSwaps = 0,
    this.bio = '',
  });

  factory UserModel.dummy(int index) {
    final names = [
      'Ali Hassan',
      'Sara Ahmed',
      'Bilal Khan',
      'Ayesha Noor',
      'Usman Malik'
    ];

    final offered = [
      ['Flutter', 'Dart'],
      ['UI/UX', 'Figma'],
      ['Python', 'ML'],
      ['Photography'],
      ['Guitar', 'Music']
    ];

    final wanted = [
      ['Photography'],
      ['Flutter'],
      ['Cooking'],
      ['Python'],
      ['Drawing']
    ];

    return UserModel(
      id: 'user_$index',
      name: names[index % names.length],
      email:
          '${names[index % names.length].split(' ')[0].toLowerCase()}@email.com',
      skillsOffered: offered[index % offered.length],
      skillsWanted: wanted[index % wanted.length],
      rating: 4.0 + (index % 10) * 0.1,
      totalSwaps: 5 + index * 3,
      bio: 'Passionate learner and teacher. Love to exchange skills!',
    );
  }

  // FIREBASE SUPPORT
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'] ?? '',
      skillsOffered: List<String>.from(map['skillsOffered'] ?? []),
      skillsWanted: List<String>.from(map['skillsWanted'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      totalSwaps: map['totalSwaps'] ?? 0,
      bio: map['bio'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'skillsOffered': skillsOffered,
      'skillsWanted': skillsWanted,
      'rating': rating,
      'totalSwaps': totalSwaps,
      'bio': bio,
    };
  }
}

// ───────────────── SKILL MODEL ─────────────────

class SkillModel {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String skillOffered;
  final String skillWanted;
  final String category;
  final double rating;
  final String description;
  final int reviewCount;

  SkillModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.skillOffered,
    required this.skillWanted,
    required this.category,
    this.rating = 0.0,
    this.description = '',
    this.reviewCount = 0,
  });

  static List<SkillModel> dummyList() {
    return [
      SkillModel(
        id: '1',
        userId: 'u1',
        userName: 'Ali Hassan',
        userImage: '',
        skillOffered: 'Flutter Dev',
        skillWanted: 'Photography',
        category: 'Technology',
        rating: 4.8,
        description: '3 years Flutter experience',
        reviewCount: 24,
      ),
      SkillModel(
        id: '2',
        userId: 'u2',
        userName: 'Sara Ahmed',
        userImage: '',
        skillOffered: 'UI/UX Design',
        skillWanted: 'Python',
        category: 'Design',
        rating: 4.6,
        description: 'Figma expert, 2+ years',
        reviewCount: 18,
      ),
    ];
  }

  // FIREBASE SUPPORT
  factory SkillModel.fromMap(Map<String, dynamic> map, String id) {
    return SkillModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      skillOffered: map['skillOffered'] ?? '',
      skillWanted: map['skillWanted'] ?? '',
      category: map['category'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'skillOffered': skillOffered,
      'skillWanted': skillWanted,
      'category': category,
      'rating': rating,
      'description': description,
      'reviewCount': reviewCount,
    };
  }
}

// ───────────────── REQUEST MODEL ─────────────────

enum RequestStatus {
  pending,
  accepted,
  completed,
  rejected,
}

class RequestModel {
  final String id;

  final String fromUserId;
  final String fromUserName;

  final String toUserId;
  final String toUserName;

  final String skillRequested;
  final String skillOffered;

  final String message;

  final RequestStatus status;

  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.toUserName,
    required this.skillRequested,
    required this.skillOffered,
    required this.message,
    this.status = RequestStatus.pending,
    required this.createdAt,
  });

  // DUMMY DATA
  static List<RequestModel> dummyList() {
    return [
      RequestModel(
        id: 'r1',
        fromUserId: 'u1',
        fromUserName: 'Ali Hassan',
        toUserId: 'u2',
        toUserName: 'Sara Ahmed',
        skillRequested: 'UI/UX Design',
        skillOffered: 'Flutter Dev',
        message: 'Would love to swap!',
        status: RequestStatus.pending,
        createdAt: DateTime.now(),
      ),
    ];
  }

  // FIREBASE SUPPORT
  factory RequestModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return RequestModel(
      id: id,

      fromUserId: map['fromUserId'] ?? '',
      fromUserName: map['fromUserName'] ?? 'Unknown User',

      toUserId: map['toUserId'] ?? '',
      toUserName: map['toUserName'] ?? 'Unknown User',

      skillRequested: map['requestedSkill'] ?? '',
      skillOffered: map['offeredSkill'] ?? '',

      message: map['message'] ?? '',

      status: _statusFromString(
        map['status'] ?? 'pending',
      ),

      createdAt: map['timestamp'] != null
          ? map['timestamp'].toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,

      'toUserId': toUserId,
      'toUserName': toUserName,

      'requestedSkill': skillRequested,
      'offeredSkill': skillOffered,

      'message': message,

      'status': status.name,

      'timestamp': createdAt,
    };
  }

  static RequestStatus _statusFromString(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return RequestStatus.accepted;

      case 'completed':
        return RequestStatus.completed;

      case 'rejected':
        return RequestStatus.rejected;

      default:
        return RequestStatus.pending;
    }
  }
}

// ───────────────── MESSAGE MODEL ─────────────────

class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  static List<MessageModel> dummyList(
    String currentUserId,
  ) {
    return [
      MessageModel(
        id: 'm1',
        senderId: 'other',
        content: 'Hi! I saw your Flutter skill listing.',
        timestamp:
            DateTime.now().subtract(
          const Duration(minutes: 30),
        ),
      ),
      MessageModel(
        id: 'm2',
        senderId: currentUserId,
        content: 'Hey! Yes, I can help with Flutter.',
        timestamp:
            DateTime.now().subtract(
          const Duration(minutes: 28),
        ),
      ),
    ];
  }

  // FIREBASE SUPPORT
  factory MessageModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] != null
          ? map['timestamp'].toDate()
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}