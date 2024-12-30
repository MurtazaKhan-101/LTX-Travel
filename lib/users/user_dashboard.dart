// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_booking_screen.dart';
import 'user_information_form.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LTX Travel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.book_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyBookingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: "E-Visa"),
                Tab(text: "Sticker Visa"),
                Tab(text: "Umrah Packages"),
                Tab(text: "International Trips"),
                Tab(text: "Domestic Trips"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPackageTab(context, 'E-Visa'),
                  _buildPackageTab(context, 'Easy Sticker Visa'),
                  _buildPackageTab(context, 'Umrah Packages'),
                  _buildPackageTab(context, 'International Trips'),
                  _buildPackageTab(context, 'Domestic Trips'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageTab(BuildContext context, String category) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('visa_packages')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inbox_outlined, size: 50, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  "No packages available.",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
          );
        }

        final packages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final packageData = packages[index].data();
            final packageId = packages[index].id;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: const Icon(Icons.flight_takeoff,
                      size: 30, color: Colors.blue),
                ),
                title: Text(
                  packageData['name'] ?? "Unnamed Package",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Price: \$${packageData['price'] ?? 'N/A'}\n"
                  "Duration: ${packageData['duration'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _navigateToBooking(context, packageData, packageId);
                  },
                  child: const Text(
                    "Book Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToBooking(BuildContext context,
      Map<String, dynamic> packageData, String packageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoForm(
          packageData: {'id': packageId, ...packageData},
          proceedToCheckoutDirectly: packageData['category'] == 'E-Visa' ||
              packageData['category'] == 'Easy Sticker Visa',
        ),
      ),
    );
  }
}
