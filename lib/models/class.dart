class Class {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final String location;
  final String instructor;

  Class({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.instructor,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'],
      instructor: json['instructor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'instructor': instructor,
    };
  }
}

