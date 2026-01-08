import 'package:equatable/equatable.dart';

class ResourceModel extends Equatable {
  final String id;
  final String title;
  final String type; // pdf, sheet, link, calendar
  final String url;
  final DateTime? updatedAt;

  const ResourceModel({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, type, url, updatedAt];

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'url': url,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
