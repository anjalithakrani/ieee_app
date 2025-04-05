class Event {
  final String id;
  final String name;
  final String date;
  final String time;
  final String location;
  final String? description;
  final String? imageUrl;
  final String organizer;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    this.description,
    this.imageUrl,
    required this.organizer,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      organizer: json['organizer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'organizer': organizer,
    };
  }
}

