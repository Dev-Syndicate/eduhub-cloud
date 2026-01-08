import 'package:equatable/equatable.dart';

class PolicyModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final String docUrl;
  final DateTime publishedDate;
  final String version;
  final String summary;

  const PolicyModel({
    required this.id,
    required this.title,
    required this.category,
    required this.docUrl,
    required this.publishedDate,
    required this.version,
    required this.summary,
  });

  @override
  List<Object?> get props =>
      [id, title, category, docUrl, publishedDate, version, summary];

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      docUrl: json['docUrl'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      version: json['version'] as String,
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'docUrl': docUrl,
      'publishedDate': publishedDate.toIso8601String(),
      'version': version,
      'summary': summary,
    };
  }
}
