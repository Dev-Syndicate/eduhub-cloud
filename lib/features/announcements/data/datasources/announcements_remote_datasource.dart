import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/announcement_model.dart';
import '../../../../core/constants/firebase_paths.dart';

/// Announcements remote data source
class AnnouncementsRemoteDataSource {
  final FirebaseFirestore _firestore;

  AnnouncementsRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all announcements
  Future<List<AnnouncementModel>> getAnnouncements({
    int limit = 20,
    String? type,
    bool? pinnedOnly,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(FirebasePaths.announcements);

    if (pinnedOnly == true) {
      query = query.where('isPinned', isEqualTo: true);
    }

    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    query = query.orderBy('publishedDate', descending: true).limit(limit);

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .toList();
  }

  /// Get announcement by ID
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    final doc =
        await _firestore.collection(FirebasePaths.announcements).doc(id).get();

    if (!doc.exists) return null;
    return AnnouncementModel.fromFirestore(doc);
  }

  /// Create new announcement
  Future<String> createAnnouncement(AnnouncementModel announcement) async {
    final docRef = await _firestore
        .collection(FirebasePaths.announcements)
        .add(announcement.toFirestore());
    return docRef.id;
  }

  /// Update announcement
  Future<void> updateAnnouncement(String id, Map<String, dynamic> data) async {
    await _firestore
        .collection(FirebasePaths.announcements)
        .doc(id)
        .update(data);
  }

  /// Toggle pin status
  Future<void> togglePin(String id, bool isPinned) async {
    await _firestore
        .collection(FirebasePaths.announcements)
        .doc(id)
        .update({'isPinned': isPinned});
  }

  /// Delete announcement
  Future<void> deleteAnnouncement(String id) async {
    await _firestore.collection(FirebasePaths.announcements).doc(id).delete();
  }

  /// Stream announcements for real-time updates
  Stream<List<AnnouncementModel>> watchAnnouncements({int limit = 20}) {
    return _firestore
        .collection(FirebasePaths.announcements)
        .orderBy('publishedDate', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AnnouncementModel.fromFirestore(doc))
            .toList());
  }
}
