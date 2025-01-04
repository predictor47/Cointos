class User {
  final String id;
  final String email;
  final String username;
  final int totalPoints;
  final int dailySpins;
  final DateTime lastSpinTime;
  final String profileImage;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.totalPoints = 0,
    this.dailySpins = 0,
    this.lastSpinTime = const DateTime(0),
    this.profileImage = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      totalPoints: json['totalPoints'] as int? ?? 0,
      dailySpins: json['dailySpins'] as int? ?? 0,
      lastSpinTime: json['lastSpinTime'] != null
          ? (json['lastSpinTime'] as Timestamp).toDate()
          : DateTime(0),
      profileImage: json['profileImage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'totalPoints': totalPoints,
      'dailySpins': dailySpins,
      'lastSpinTime': Timestamp.fromDate(lastSpinTime),
      'profileImage': profileImage,
    };
  }

  User copyWith({
    String? email,
    String? username,
    int? totalPoints,
    int? dailySpins,
    DateTime? lastSpinTime,
    String? profileImage,
  }) {
    return User(
      id: id,
      email: email ?? this.email,
      username: username ?? this.username,
      totalPoints: totalPoints ?? this.totalPoints,
      dailySpins: dailySpins ?? this.dailySpins,
      lastSpinTime: lastSpinTime ?? this.lastSpinTime,
      profileImage: profileImage ?? this.profileImage,
    );
  }
} 