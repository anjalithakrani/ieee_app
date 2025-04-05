class Club {
  final String id;
  final String name;
  final String description;
  final String type;
  final String? imageUrl;
  final int memberCount;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.imageUrl,
    required this.memberCount,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      imageUrl: json['imageUrl'],
      memberCount: json['memberCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'imageUrl': imageUrl,
      'memberCount': memberCount,
    };
  }
}

