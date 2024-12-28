import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> packageData;
  final Map<String, dynamic>? selectedHotel;
  final Map<String, dynamic>? selectedTransport;

  const CheckoutScreen({
    super.key,
    required this.packageData,
    this.selectedHotel,
    this.selectedTransport,
  });

  Future<void> _storeBookingData(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }

      final bookingData = {
        'userId': user.uid,
        'packageId': packageData['id'],
        'packageName': packageData['name'],
        'category': packageData['category'],
        'price': packageData['price'],
        'userInfo': packageData['userInfo'],
        'selectedHotel': selectedHotel,
        'selectedTransport': selectedTransport,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking completed successfully!')),
      );
      Navigator.pushNamedAndRemoveUntil(
          context, '/userDashboard', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Package Details"),
                _buildDetailRow("Category", packageData['category']),
                _buildDetailRow("Package", packageData['name']),
                _buildDetailRow("Price", "\$${packageData['price']}"),
                const SizedBox(height: 16),
                if (packageData['userInfo'] != null) ...[
                  _buildSectionTitle("User Information"),
                  _buildDetailRow(
                      "Full Name", packageData['userInfo']['fullName']),
                  _buildDetailRow("Email", packageData['userInfo']['email']),
                  _buildDetailRow("Mobile", packageData['userInfo']['mobile']),
                  _buildDetailRow(
                      "Payer Status", packageData['userInfo']['payerStatus']),
                  _buildDetailRow(
                      "Passport", packageData['userInfo']['passportNumber']),
                  const SizedBox(height: 16),
                ],
                if (selectedHotel != null) ...[
                  _buildSectionTitle("Hotel Details"),
                  _buildDetailRow("Hotel", selectedHotel!['name']),
                  const SizedBox(height: 16),
                ],
                if (selectedTransport != null) ...[
                  _buildSectionTitle("Transport Details"),
                  _buildDetailRow("Transport", selectedTransport!['name']),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _storeBookingData(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirm Booking',
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
