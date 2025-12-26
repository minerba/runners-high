class EventModel {
  final String id;
  final String title;
  final String? description;
  final String? eventUrl;
  final String? imageUrl;
  final DateTime? eventDate;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EventModel({
    required this.id,
    required this.title,
    this.description,
    this.eventUrl,
    this.imageUrl,
    this.eventDate,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventUrl: json['event_url'] as String?,
      imageUrl: json['image_url'] as String?,
      eventDate: json['event_date'] != null
          ? DateTime.parse(json['event_date'] as String)
          : null,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_url': eventUrl,
      'image_url': imageUrl,
      'event_date': eventDate?.toIso8601String(),
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
