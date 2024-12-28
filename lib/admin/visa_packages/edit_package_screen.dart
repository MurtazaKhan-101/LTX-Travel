import 'package:flutter/material.dart';
import 'visa_package_service.dart';

class EditPackageScreen extends StatefulWidget {
  final String packageId;
  final Map<String, dynamic> data;

  const EditPackageScreen({
    required this.packageId,
    required this.data,
    super.key,
  });

  @override
  State<EditPackageScreen> createState() => _EditPackageScreenState();
}

class _EditPackageScreenState extends State<EditPackageScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController durationController;
  late String category;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.data['name']);
    priceController =
        TextEditingController(text: widget.data['price'].toString());
    descriptionController =
        TextEditingController(text: widget.data['description']);
    durationController =
        TextEditingController(text: widget.data['duration'].toString());
    category = widget.data['category'];
  }

  void _deletePackage() async {
    bool confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Package"),
            content: const Text(
                "Are you sure you want to delete this package? This action cannot be undone."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmDelete) {
      await VisaPackageService.deletePackage(widget.packageId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Package deleted successfully!")),
      );
      Navigator.pop(context);
    }
  }

  void _updatePackage() async {
    await VisaPackageService.updatePackage(
      widget.packageId,
      {
        'name': nameController.text,
        'category': category,
        'price': double.parse(priceController.text),
        'description': descriptionController.text,
        'duration': durationController.text,
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Package updated successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Visa Package"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: category,
                        items: const [
                          DropdownMenuItem(
                              value: "E-Visa", child: Text("E-Visa")),
                          DropdownMenuItem(
                              value: "Easy Sticker Visa",
                              child: Text("Easy Sticker Visa")),
                          DropdownMenuItem(
                              value: "Umrah Packages",
                              child: Text("Umrah Packages")),
                          DropdownMenuItem(
                              value: "International Trips",
                              child: Text("International Trips")),
                          DropdownMenuItem(
                              value: "Domestic Trips",
                              child: Text("Domestic Trips")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Category",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          prefixIcon: const Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Price",
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Description",
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: durationController,
                        decoration: InputDecoration(
                          labelText: "Duration",
                          prefixIcon: const Icon(Icons.timer),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updatePackage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text("Update Package"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _deletePackage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 245, 103, 93),
                        ),
                        child: const Text("Delete Package"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    super.dispose();
  }
}
