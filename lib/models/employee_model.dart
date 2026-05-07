class Employee {
  final int id;
  final String name;
  final String email;
  final String position;
  final DateTime joiningDate;
  final bool isActive;
  final double yearsOfService;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.joiningDate,
    required this.isActive,
    required this.yearsOfService,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      position: json['position'],
      joiningDate: DateTime.parse(json['joining_date']),
      isActive: json['is_active'] is bool
          ? json['is_active']
          : json['is_active'] == 1,
      yearsOfService: json['years_of_service'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
      'joining_date': joiningDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'years_of_service': yearsOfService,
    };
  }

  bool get shouldHighlight =>
      isActive && yearsOfService > 5;
}