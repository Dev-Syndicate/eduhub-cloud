import 'package:cloud_firestore/cloud_firestore.dart';

/// Base repository interface for Firestore operations
abstract class BaseRepository<T> {
  final FirebaseFirestore _firestore;
  final String collectionPath;

  BaseRepository({
    FirebaseFirestore? firestore,
    required this.collectionPath,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get Firestore instance
  FirebaseFirestore get firestore => _firestore;

  /// Get collection reference
  CollectionReference<Map<String, dynamic>> get collection =>
      _firestore.collection(collectionPath);

  /// Get document reference
  DocumentReference<Map<String, dynamic>> docRef(String id) =>
      collection.doc(id);

  /// Convert Firestore document to model (must be implemented)
  T fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc);

  /// Convert model to Firestore map (must be implemented)
  Map<String, dynamic> toFirestore(T model);

  /// Get single document by ID
  Future<T?> getById(String id) async {
    final doc = await docRef(id).get();
    if (!doc.exists) return null;
    return fromFirestore(doc);
  }

  /// Get all documents
  Future<List<T>> getAll({int? limit}) async {
    Query<Map<String, dynamic>> query = collection;
    if (limit != null) {
      query = query.limit(limit);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
  }

  /// Create new document
  Future<String> create(T model) async {
    final docRef = await collection.add(toFirestore(model));
    return docRef.id;
  }

  /// Create document with specific ID
  Future<void> createWithId(String id, T model) async {
    await docRef(id).set(toFirestore(model));
  }

  /// Update existing document
  Future<void> update(String id, Map<String, dynamic> data) async {
    await docRef(id).update(data);
  }

  /// Delete document
  Future<void> delete(String id) async {
    await docRef(id).delete();
  }

  /// Query documents with conditions
  Future<List<T>> query({
    required String field,
    required dynamic isEqualTo,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    Query<Map<String, dynamic>> query =
        collection.where(field, isEqualTo: isEqualTo);

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
  }

  /// Listen to document changes
  Stream<T?> watchById(String id) {
    return docRef(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return fromFirestore(doc);
    });
  }

  /// Listen to collection changes
  Stream<List<T>> watchAll({int? limit}) {
    Query<Map<String, dynamic>> query = collection;
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => fromFirestore(doc)).toList(),
        );
  }
}
