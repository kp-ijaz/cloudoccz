class TaskModel {
  final int id;
  final String name;
  final String description;
  final String? deadline; // Nullable deadline

  TaskModel({
    required this.id,
    required this.name,
    required this.description,
    this.deadline,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      deadline: json['deadline'], // Allow null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'deadline': deadline, // Allow null
    };
  }
}
