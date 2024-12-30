import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_details_screen.dart';

class BookingManagementScreen extends StatelessWidget {
  const BookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final packageCategories = [
      "E-Visa",
      "Easy Sticker Visa",
      "Umrah Packages",
      "International Trips",
      "Domestic Trips"
    ];

    return DefaultTabController(
      length: packageCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Bookings"),
          bottom: TabBar(
            isScrollable: true,
            tabs: packageCategories
                .map((category) => Tab(text: category))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: packageCategories.map((category) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('category', isEqualTo: category)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text("No bookings available for $category."));
                  }

                  final bookings = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      final data = booking.data();

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 4,
                        child: ListTile(
                          title: Text(data['packageName'] ?? "Unnamed Package"),
                          subtitle:
                              Text("Status: ${data['status'] ?? 'Pending'}"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetailsScreen(
                                  bookingId: booking.id,
                                  bookingData: data,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
