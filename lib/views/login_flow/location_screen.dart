import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/constants/colors.dart';
import 'package:super_nova/controllers/login_flow/user_location_controller.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  void _goToMap() {
    Get.toNamed('/map');
  }

  void _useCurrentLocation() async {
    final controller = Get.put(UserLocationController());
    await controller.getCurrentLocation();
    await controller.onSetLocation();
  }

  final controller = Get.put(UserLocationController());

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
              height: 100,
            ),
            Image.asset(
              'assets/icon_marker.png',
              fit: BoxFit.cover,
              width: 54,
              height: 64,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hello, nice to meet you!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const Text(
              'Set your location to start find car wash around you',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.location_on),
                      label: controller.isLoadingCurrentLocation.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Use Current Location"),
                      onPressed: controller.isLoadingCurrentLocation.value
                          ? null
                          : _useCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.activeButton,
                        foregroundColor: AppColors.white,
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (controller.currentLocationText.isNotEmpty)
                      Text(
                        'Current Location: ${controller.currentLocationText.value}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      )
                  ],
                )),
            const SizedBox(height: 20),
            const Text(
              'We only access your location while you are using this incredible app',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _goToMap(),
              child: const Text(
                "or set your location manually",
                style: TextStyle(color: AppColors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
