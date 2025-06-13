import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_nova/constants/colors.dart';

import '../../db/firestore_service.dart';

class BrandCarsScreen extends StatelessWidget {
  BrandCarsScreen({super.key});
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final String brand = Get.arguments;
    final cars = ['Model A', 'Model B', 'Model C']; // Dummy cars

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(
            "$brand Cars",
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: 40,
                fontWeight: FontWeight.w700),
          )),
      body: ListView(
        children: cars
            .map((car) => ListTile(
                title: Text(car),
                onTap: () async {
                  await firestoreService.saveCarDetails(
                    brand: brand,
                    car: car,
                  );
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('completed_user_flow', true);
                  Get.offAllNamed('/user-dashboard');
                }))
            .toList(),
      ),
    );
  }
}
