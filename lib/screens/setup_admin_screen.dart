import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetupAdminScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SetupAdminScreen({super.key});

  void createAdminAccount(String email, String password) async {
    try {
      // Create the admin user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Add admin data to Firestore
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(userCredential.user!.uid)
          .set({
        'adminId': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'email': email,
      });

      // print('Admin created successfully');
    } catch (e) {
      // print("Error creating admin: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Admin Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Admin Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createAdminAccount(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: const Text('Create Admin Account'),
            ),
          ],
        ),
      ),
    );
  }
}
