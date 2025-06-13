import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/constants/colors.dart';

final carBrands = ['Hyundai', 'Toyota', 'Honda', 'Tata', 'Mahindra'];

class BrandListScreen extends StatelessWidget {
  const BrandListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Select Vehicle",
          style: TextStyle(
              color: AppColors.primary,
              fontSize: 40,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.builder(
        itemCount: carBrands.length,
        itemBuilder: (context, index) {
          final brand = carBrands[index];
          return ListTile(
              title: Text(brand),
              // onTap: () => Get.toNamed('/brand-cars', arguments: brand),
              onTap: () async {
                // final uid = FirebaseAuth.instance.currentUser?.uid;
                // if (uid != null) {
                //   await FirebaseFirestore.instance
                //       .collection('users')
                //       .doc(uid)
                //       .set({
                //     'userDetails.selectedBrand': brand,
                //   }, SetOptions(merge: true));
                // }
                Get.toNamed('/brand-cars', arguments: brand);
              });
        },
      ),
    );
  }
}
