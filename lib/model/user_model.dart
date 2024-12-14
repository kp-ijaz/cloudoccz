class UserModel {
  final String email;
  final String token;
  final String name;
  final String image;
  final String position;
  final int noOfTasks;
  final int percentage;

  UserModel({
    required this.email,
    required this.token,
    required this.name,
    required this.image,
    required this.position,
    required this.noOfTasks,
    required this.percentage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      position: json['position'] ?? '',
      noOfTasks: json['no_of_task'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}
