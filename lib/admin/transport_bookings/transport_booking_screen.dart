import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_transport_screen.dart';
import 'edit_transport_screen.dart';
import 'transport_booking_service.dart';

class TransportBookingScreen extends StatelessWidget {
  const TransportBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transport'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bus'),
              Tab(text: 'Boat'),
              Tab(text: 'Car'),
              Tab(text: 'Train'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TransportCategoryScreen(category: 'Bus'),
            TransportCategoryScreen(category: 'Boat'),
            TransportCategoryScreen(category: 'Car'),
            TransportCategoryScreen(category: 'Train'),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                // Get the current tab index
                final tabIndex = DefaultTabController.of(context).index;

                // Map the index to the corresponding category
                final categories = ['Bus', 'Boat', 'Car', 'Train'];
                final selectedCategory = categories[tabIndex];

                // Navigate to AddTransportScreen with the selected category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddTransportScreen(category: selectedCategory),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

class TransportCategoryScreen extends StatelessWidget {
  final String category;

  const TransportCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: TransportBookingService.getTransportBookings(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Transport Found.'));
            }

            final bookings = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final data = bookings[index].data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    title: Text(data['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${data['location']}'),
                        Text('Price: \$${data['price']}'),
                        Text('Capacity: ${data['capacity']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTransportScreen(
                              transportId: bookings[index].id,
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
        ));
  }
}
