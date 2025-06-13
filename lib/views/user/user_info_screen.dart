import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/constants/colors.dart';
import '../../db/firestore_service.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController communityController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void _submit() async {
    if (communityController.text.isEmpty || vehicleController.text.isEmpty) {
      Get.snackbar('Missing Info', 'Community and vehicle number are required');
      return;
    }
    await firestoreService.saveUserDetails(
      community: communityController.text,
      vehicle: vehicleController.text,
      contact: contactController.text,
    );
    Get.toNamed('/brands');
  }

  Future<void> fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userName = doc.data()?['name'] ?? 'Customer';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Welcome to Supernova Auto Glow!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Hey ${userName ?? "Customer"}, your shine awaits!',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextField(
              controller: communityController,
              decoration: const InputDecoration(labelText: "Community Name"),
            ),
            TextField(
              controller: vehicleController,
              decoration: const InputDecoration(labelText: "Vehicle Number"),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                  labelText: "Point of Contact (optional)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF0184D2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Choose your Car",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
