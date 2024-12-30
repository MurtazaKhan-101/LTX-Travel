import 'package:flutter/material.dart';
import 'view_package_list.dart';
import 'create_package_screen.dart';

class VisaPackagesScreen extends StatelessWidget {
  const VisaPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "E-Visa",
      "Easy Sticker Visa",
      "Umrah Packages",
      "International Trips",
      "Domestic Trips",
    ];

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Visa Packages"),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories
              .map((category) => ViewPackageList(category: category))
              .toList(),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final tabIndex = DefaultTabController.of(context).index;
                final selectedCategory = categories[tabIndex];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreatePackageScreen(selectedCategory: selectedCategory),
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
