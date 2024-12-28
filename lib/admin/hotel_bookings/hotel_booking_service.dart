import 'package:cloud_firestore/cloud_firestore.dart';

class HotelBookingService {
  static final _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getHotelBookings() {
    return _firestore.collection('hotel_bookings').snapshots();
  }

  static Future<void> addHotel(Map<String, dynamic> data) {
    return _firestore.collection('hotel_bookings').add(data);
  }

  static Future<void> updateHotel(String hotelId, Map<String, dynamic> data) {
    return _firestore.collection('hotel_bookings').doc(hotelId).update(data);
  }

  static Future<void> deleteHotel(String hotelId) {
    return _firestore.collection('hotel_bookings').doc(hotelId).delete();
  }
}
