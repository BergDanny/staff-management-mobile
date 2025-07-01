import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/staff.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'staff';

  // Add a new staff member
  Future<void> addStaff(Staff staff) async {
    try {
      await _firestore.collection(_collectionName).add(staff.toMap());
    } catch (e) {
      throw Exception('Failed to add staff: $e');
    }
  }

  // Get all staff members
  Stream<List<Staff>> getStaff() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Staff.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Update a staff member
  Future<void> updateStaff(Staff staff) async {
    try {
      if (staff.id == null) {
        throw Exception('Staff ID is required for update');
      }
      await _firestore
          .collection(_collectionName)
          .doc(staff.id)
          .update(staff.toMap());
    } catch (e) {
      throw Exception('Failed to update staff: $e');
    }
  }

  // Delete a staff member
  Future<void> deleteStaff(String staffId) async {
    try {
      await _firestore.collection(_collectionName).doc(staffId).delete();
    } catch (e) {
      throw Exception('Failed to delete staff: $e');
    }
  }

  // Check if staff ID already exists
  Future<bool> isStaffIdExists(String staffId, {String? excludeDocId}) async {
    try {
      Query query = _firestore
          .collection(_collectionName)
          .where('staffId', isEqualTo: staffId);

      final snapshot = await query.get();

      if (excludeDocId != null) {
        // Exclude the current document when checking for updates
        return snapshot.docs.any((doc) => doc.id != excludeDocId);
      }

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check staff ID: $e');
    }
  }
}
