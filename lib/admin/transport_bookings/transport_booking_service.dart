import 'package:cloud_firestore/cloud_firestore.dart';

class TransportBookingService {
  static final _firestore = FirebaseFirestore.instance;

  // Retrieve transport bookings by category
  static Stream<QuerySnapshot> getTransportBookings(String category) {
    return _firestore
        .collection('transport_bookings')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  // Add a new transport booking
  static Future<void> addTransportBooking(Map<String, dynamic> data) {
    return _firestore.collection('transport_bookings').add(data);
  }

  // Update an existing transport booking
  static Future<void> updateTransportBooking(
      String id, Map<String, dynamic> updatedData) {
    return _firestore
        .collection('transport_bookings')
        .doc(id)
        .update(updatedData);
  }

  // Delete a transport booking
  static Future<void> deleteTransportBooking(String id) {
    return _firestore.collection('transport_bookings').doc(id).delete();
  }
}
