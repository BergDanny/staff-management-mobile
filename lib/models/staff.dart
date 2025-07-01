class Staff {
  final String? id;
  final String name;
  final String staffId;
  final int age;
  final String department;
  final DateTime createdAt;

  Staff({
    this.id,
    required this.name,
    required this.staffId,
    required this.age,
    required this.department,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Staff object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'staffId': staffId,
      'age': age,
      'department': department,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Staff object from Firestore document
  factory Staff.fromMap(Map<String, dynamic> map, String documentId) {
    return Staff(
      id: documentId,
      name: map['name'] ?? '',
      staffId: map['staffId'] ?? '',
      age: map['age'] ?? 0,
      department: map['department'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Create a copy of Staff with updated fields
  Staff copyWith({
    String? id,
    String? name,
    String? staffId,
    int? age,
    String? department,
    DateTime? createdAt,
  }) {
    return Staff(
      id: id ?? this.id,
      name: name ?? this.name,
      staffId: staffId ?? this.staffId,
      age: age ?? this.age,
      department: department ?? this.department,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
