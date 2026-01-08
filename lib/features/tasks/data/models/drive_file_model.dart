import 'package:equatable/equatable.dart';

/// Drive file model for Google Drive files
class DriveFileModel extends Equatable {
  final String id;
  final String name;
  final String mimeType;
  final String? webViewLink;
  final String? webContentLink;
  final String? thumbnailLink;
  final DateTime? modifiedTime;
  final int? size;
  final String? iconLink;

  const DriveFileModel({
    required this.id,
    required this.name,
    required this.mimeType,
    this.webViewLink,
    this.webContentLink,
    this.thumbnailLink,
    this.modifiedTime,
    this.size,
    this.iconLink,
  });

  /// Create from Google Drive API response
  factory DriveFileModel.fromJson(Map<String, dynamic> json) {
    return DriveFileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mimeType: json['mimeType'] ?? '',
      webViewLink: json['webViewLink'],
      webContentLink: json['webContentLink'],
      thumbnailLink: json['thumbnailLink'],
      modifiedTime: json['modifiedTime'] != null
          ? DateTime.parse(json['modifiedTime'])
          : null,
      size: json['size'] != null ? int.tryParse(json['size'].toString()) : null,
      iconLink: json['iconLink'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mimeType': mimeType,
      'webViewLink': webViewLink,
      'webContentLink': webContentLink,
      'thumbnailLink': thumbnailLink,
      'modifiedTime': modifiedTime?.toIso8601String(),
      'size': size,
      'iconLink': iconLink,
    };
  }

  /// Check if file is a folder
  bool get isFolder => mimeType == 'application/vnd.google-apps.folder';

  /// Check if file is a Google Doc
  bool get isGoogleDoc =>
      mimeType == 'application/vnd.google-apps.document';

  /// Check if file is a Google Sheet
  bool get isGoogleSheet =>
      mimeType == 'application/vnd.google-apps.spreadsheet';

  /// Check if file is a PDF
  bool get isPdf => mimeType == 'application/pdf';

  /// Get file extension
  String? get extension {
    if (name.contains('.')) {
      return name.split('.').last.toLowerCase();
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        mimeType,
        webViewLink,
        webContentLink,
        thumbnailLink,
        modifiedTime,
        size,
        iconLink,
      ];
}
