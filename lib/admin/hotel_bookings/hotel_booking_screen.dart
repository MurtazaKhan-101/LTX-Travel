import 'package:flutter/material.dart';
import 'add_hotel_screen.dart';
import 'edit_hotel_screen.dart';
import 'hotel_booking_service.dart';

class HotelBookingScreen extends StatelessWidget {
  const HotelBookingScreen({super.key});

  // Function to build star ratings
  Widget buildStarRating(double rating) {
    int fullStars = rating.floor(); // Number of full stars
    bool hasHalfStar =
        (rating - fullStars) >= 0.5; // Check if there's a half star

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.yellow); // Full star
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.yellow); // Half star
        } else {
          return const Icon(Icons.star_border,
              color: Colors.grey); // Empty star
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hotels")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: HotelBookingService.getHotelBookings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No hotel listed."));
            }

            final bookings = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final data = bookings[index].data() as Map<String, dynamic>;
                final double rating = (data['rating'] ?? 0).toDouble();

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      data['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data['location']} • \$${data['price']}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        buildStarRating(rating), // Display star ratings
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditHotelScreen(
                              hotelId: bookings[index].id,
                              data: data,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHotelScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
