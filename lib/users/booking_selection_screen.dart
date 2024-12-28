import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'checkout_screen.dart';

class BookingSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> packageData;

  const BookingSelectionScreen({super.key, required this.packageData});

  @override
  State<BookingSelectionScreen> createState() => _BookingSelectionScreenState();
}

class _BookingSelectionScreenState extends State<BookingSelectionScreen> {
  Map<String, dynamic>? selectedHotel;
  Map<String, dynamic>? selectedTransport;

  bool get showOptions =>
      widget.packageData['category'] == 'Umrah Packages' ||
      widget.packageData['category'] == 'International Trips' ||
      widget.packageData['category'] == 'Domestic Trips';

  void toggleSelection(Map<String, dynamic> data, String type, String docId) {
    setState(() {
      if (type == 'hotel') {
        if (selectedHotel?['id'] == docId) {
          selectedHotel = null; // Unselect if the same hotel is selected
        } else {
          selectedHotel = data; // Select the new hotel
          selectedHotel!['id'] = docId; // Add document ID to the selected hotel
        }
      } else if (type == 'transport') {
        if (selectedTransport?['id'] == docId) {
          selectedTransport =
              null; // Unselect if the same transport is selected
        } else {
          selectedTransport = data; // Select the new transport
          selectedTransport!['id'] =
              docId; // Add document ID to the selected transport
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Options")),
      body: showOptions
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Hotels",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildList('hotel_bookings', 'hotel'),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Transport",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildList('transport_bookings', 'transport'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              packageData: widget.packageData,
                              selectedHotel: selectedHotel,
                              selectedTransport: selectedTransport,
                            ),
                          ),
                        );
                      },
                      child: const Text("Proceed to Checkout"),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text("No options available for this category."),
            ),
    );
  }

  Widget _buildList(String collection, String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(type == 'hotel'
                  ? "No Hotels available."
                  : "No Transport options available."));
        }

        final items = snapshot.data!.docs.where((doc) {
          final data = doc.data();

          if (type == 'hotel') {
            if (widget.packageData['category'] == 'Umrah Packages') {
              final hotelLocation = data['location'].toString().toLowerCase();
              return hotelLocation.contains('makkah') ||
                  hotelLocation.contains('madina');
            } else {
              final packageName =
                  widget.packageData['name'].toString().toLowerCase();
              final hotelLocation = data['location'].toString().toLowerCase();
              return hotelLocation.contains(packageName);
            }
          }

          // No filtering for transport
          return true;
        }).toList();

        if (items.isEmpty) {
          return Center(
              child: Text(type == 'hotel'
                  ? "No matching Hotels available."
                  : "No matching Transport options available."));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index].data();
            final docId = items[index].id; // Get the document ID
            return _buildCard(data, type, docId);
          },
        );
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> data, String type, String docId) {
    final isSelected = (type == 'hotel' && selectedHotel?['id'] == docId) ||
        (type == 'transport' && selectedTransport?['id'] == docId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          data['name'] ?? "Unnamed ${type.capitalize()}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: type == 'hotel'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location: ${data['location']}"),
                  Text("Price: \$${data['price']}"),
                  _buildRatingStars(data['rating'] ?? 0),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location: ${data['location']}"),
                  Text("Price: \$${data['price']}"),
                  Text("Capacity: ${data['capacity']}"),
                  Text("Category: ${data['category']}"),
                ],
              ),
        trailing: ElevatedButton(
          onPressed: () => toggleSelection(data, type, docId),
          style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.red : Colors.blue),
          child: Text(isSelected ? "Unselect" : "Select"),
        ),
      ),
    );
  }

  Widget _buildRatingStars(dynamic rating) {
    // Ensure rating is treated as a double
    double ratingValue = (rating is int) ? rating.toDouble() : (rating ?? 0.0);
    int fullStars = ratingValue.floor();
    bool hasHalfStar = (ratingValue - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber);
        }
      }),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
