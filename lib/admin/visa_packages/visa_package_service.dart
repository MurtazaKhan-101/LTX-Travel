import 'package:cloud_firestore/cloud_firestore.dart';

class VisaPackageService {
  static final _collection =
      FirebaseFirestore.instance.collection('visa_packages');

  static Future<void> createPackage({
    required String name,
    required String category,
    required double price,
    required String description,
    required String duration,
  }) async {
    await _collection.add({
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'duration': duration,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deletePackage(String packageId) async {
    await _collection.doc(packageId).delete();
  }

  static Future<void> updatePackage(
      String packageId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _collection.doc(packageId).update(data);
  }
}
