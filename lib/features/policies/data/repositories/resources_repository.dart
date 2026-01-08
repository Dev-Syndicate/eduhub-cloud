import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resource_model.dart';
import '../../../../core/enums/resource_type.dart';

/// Repository for managing campus resources
class ResourcesRepository {
  final FirebaseFirestore _firestore;

  ResourcesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all resources
  Future<List<ResourceModel>> getResources() async {
    try {
      final snapshot = await _firestore
          .collection('resources')
          .orderBy('lastUpdated', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ResourceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch resources: $e');
    }
  }

  /// Get resource by ID
  Future<ResourceModel?> getResourceById(String id) async {
    try {
      final doc = await _firestore.collection('resources').doc(id).get();

      if (!doc.exists) return null;

      return ResourceModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch resource: $e');
    }
  }

  /// Get resources by type
  Future<List<ResourceModel>> getResourcesByType(ResourceType type) async {
    try {
      final snapshot = await _firestore
          .collection('resources')
          .where('type', isEqualTo: type.value)
          .orderBy('lastUpdated', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ResourceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch resources by type: $e');
    }
  }

  /// Stream of resources
  Stream<List<ResourceModel>> resourcesStream() {
    return _firestore
        .collection('resources')
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ResourceModel.fromFirestore(doc))
            .toList());
  }

  /// Create resource (admin only)
  Future<void> createResource(ResourceModel resource) async {
    try {
      await _firestore
          .collection('resources')
          .doc(resource.id)
          .set(resource.toFirestore());
    } catch (e) {
      throw Exception('Failed to create resource: $e');
    }
  }

  /// Update resource (admin only)
  Future<void> updateResource(ResourceModel resource) async {
    try {
      await _firestore
          .collection('resources')
          .doc(resource.id)
          .update(resource.toFirestore());
    } catch (e) {
      throw Exception('Failed to update resource: $e');
    }
  }

  /// Delete resource (admin only)
  Future<void> deleteResource(String id) async {
    try {
      await _firestore.collection('resources').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete resource: $e');
    }
  }
}
