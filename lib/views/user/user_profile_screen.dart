// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/controllers/user_profile/user_profile_controller.dart';

// ignore: use_key_in_widget_constructors
class UserProfileScreen extends StatelessWidget {
  final controller = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                color: const Color(0xFF00184D2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () => Get.toNamed('/user-settings'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Settings button
                        ElevatedButton(
                          onPressed: () => Get.toNamed('/user-settings'),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Color(0xFF000000033),
                          ),
                          child: const Icon(Icons.settings,
                              size: 18, color: Colors.white),
                        ),

                        // Profile image with name and email
                        Column(
                          children: [
                            Obx(() => CircleAvatar(
                                  radius: 45,
                                  backgroundImage:
                                      controller.userPhoto.value.isNotEmpty
                                          ? FileImage(
                                              File(controller.userPhoto.value))
                                          : const AssetImage(
                                                  'assets/splash_logo.png')
                                              as ImageProvider,
                                )),
                            const SizedBox(height: 8),
                            Obx(() => Text(
                                  controller.userName.value,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                )),
                            Obx(() => Text(
                                  controller.userEmail.value,
                                  style: const TextStyle(color: Colors.white70),
                                )),
                          ],
                        ),

                        // Edit profile image button
                        ElevatedButton(
                          onPressed: () {
                            // controller.pickAndUploadImage(); // Uncomment when implemented
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: const Color(0xFF05AC8FA),
                          ),
                          child: const Icon(Icons.edit,
                              size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Obx(() => Text(controller.userAddress.value,
                        style: const TextStyle(color: Colors.black87))),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add new address',
                            style: TextStyle(color: Colors.blue)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add, color: Colors.blue))
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Current Plan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 10),
                    Obx(
                      () => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF00B4B89),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${controller.plan.value} Package",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.check,
                                      color: Colors.white, size: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text("${controller.washes.value} Washes ₹XXX/month",
                                style:
                                    const TextStyle(color: Colors.amberAccent)),
                            const SizedBox(height: 6),
                            Text(
                              "${controller.remainingWashes.value} Washes remaining • ${controller.daysLeft.value} Days left",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
