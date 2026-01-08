import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/policy_model.dart';
import '../../../../core/enums/policy_category.dart';

/// Repository for managing policies
class PoliciesRepository {
  final FirebaseFirestore _firestore;

  PoliciesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all policies
  Future<List<PolicyModel>> getPolicies() async {
    try {
      final snapshot = await _firestore
          .collection('policies')
          .orderBy('lastUpdated', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PolicyModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch policies: $e');
    }
  }

  /// Get policy by ID
  Future<PolicyModel?> getPolicyById(String id) async {
    try {
      final doc = await _firestore.collection('policies').doc(id).get();

      if (!doc.exists) return null;

      return PolicyModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch policy: $e');
    }
  }

  /// Get policies by category
  Future<List<PolicyModel>> getPoliciesByCategory(
      PolicyCategory category) async {
    try {
      final snapshot = await _firestore
          .collection('policies')
          .where('category', isEqualTo: category.value)
          .orderBy('lastUpdated', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PolicyModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch policies by category: $e');
    }
  }

  /// Search policies by title
  Future<List<PolicyModel>> searchPolicies(String query) async {
    try {
      final snapshot = await _firestore
          .collection('policies')
          .orderBy('title')
          .get();

      // Filter locally since Firestore doesn't support full-text search
      final policies = snapshot.docs
          .map((doc) => PolicyModel.fromFirestore(doc))
          .where((policy) =>
              policy.title.toLowerCase().contains(query.toLowerCase()) ||
              policy.summary.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return policies;
    } catch (e) {
      throw Exception('Failed to search policies: $e');
    }
  }

  /// Stream of policies
  Stream<List<PolicyModel>> policiesStream() {
    return _firestore
        .collection('policies')
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PolicyModel.fromFirestore(doc)).toList());
  }

  /// Create policy (admin only)
  Future<void> createPolicy(PolicyModel policy) async {
    try {
      await _firestore
          .collection('policies')
          .doc(policy.id)
          .set(policy.toFirestore());
    } catch (e) {
      throw Exception('Failed to create policy: $e');
    }
  }

  /// Update policy (admin only)
  Future<void> updatePolicy(PolicyModel policy) async {
    try {
      await _firestore
          .collection('policies')
          .doc(policy.id)
          .update(policy.toFirestore());
    } catch (e) {
      throw Exception('Failed to update policy: $e');
    }
  }

  /// Delete policy (admin only)
  Future<void> deletePolicy(String id) async {
    try {
      await _firestore.collection('policies').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete policy: $e');
    }
  }
}
