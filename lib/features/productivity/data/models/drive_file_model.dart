import 'package:equatable/equatable.dart';

class DriveFileModel extends Equatable {
  final String id;
  final String name;
  final String type; // pdf, sheet, doc, slide, folder, other
  final String url;
  final DateTime modifiedAt;
  final String size;

  const DriveFileModel({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.modifiedAt,
    required this.size,
  });

  @override
  List<Object?> get props => [id, name, type, url, modifiedAt, size];

  factory DriveFileModel.fromJson(Map<String, dynamic> json) {
    return DriveFileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      size: json['size'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'modifiedAt': modifiedAt.toIso8601String(),
      'size': size,
    };
  }
}
