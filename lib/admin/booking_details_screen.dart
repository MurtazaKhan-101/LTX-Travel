import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> bookingData;

  const BookingDetailsScreen({
    required this.bookingId,
    required this.bookingData,
    super.key,
  });

  Future<void> updateBookingStatus(BuildContext context, String status) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm $status"),
        content: Text("Are you sure you want to mark this booking as $status?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking marked as $status")),
      );
      Navigator.pop(context);
    }
  }

  Widget buildSection(String title, Widget content) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(child: Text(value?.toString() ?? "N/A")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildSection(
                "Package Details",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(
                        "Package Name", bookingData['packageName'] ?? 'N/A'),
                    buildDetailRow(
                        "Category", bookingData['category'] ?? 'N/A'),
                    buildDetailRow("Price", bookingData['price'] ?? 'N/A'),
                  ],
                ),
              ),
              buildSection(
                "Selected Hotel",
                bookingData['selectedHotel'] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDetailRow(
                              "Name", bookingData['selectedHotel']['name']),
                          buildDetailRow("Location",
                              bookingData['selectedHotel']['location']),
                          buildDetailRow(
                              "Price", bookingData['selectedHotel']['price']),
                          buildDetailRow(
                              "Rating", bookingData['selectedHotel']['rating']),
                        ],
                      )
                    : const Text("No hotel selected."),
              ),
              buildSection(
                "Selected Transport",
                bookingData['selectedTransport'] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDetailRow(
                              "Name", bookingData['selectedTransport']['name']),
                          buildDetailRow("Category",
                              bookingData['selectedTransport']['category']),
                          buildDetailRow("Capacity",
                              bookingData['selectedTransport']['capacity']),
                          buildDetailRow("Price",
                              bookingData['selectedTransport']['price']),
                        ],
                      )
                    : const Text("No transport selected."),
              ),
              buildSection(
                "User Information",
                bookingData['userInfo'] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDetailRow(
                              "Full Name", bookingData['userInfo']['fullName']),
                          buildDetailRow(
                              "Email", bookingData['userInfo']['email']),
                          buildDetailRow(
                              "Mobile", bookingData['userInfo']['mobile']),
                          buildDetailRow("Passport Number",
                              bookingData['userInfo']['passportNumber']),
                          buildDetailRow("Payer Status",
                              bookingData['userInfo']['payerStatus']),
                        ],
                      )
                    : const Text("No user information available."),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => updateBookingStatus(context, "Completed"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Approve Booking",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                      onPressed: () => updateBookingStatus(context, "Rejected"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 245, 103, 93),
                      ),
                      child: const Text("Reject Booking",
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
