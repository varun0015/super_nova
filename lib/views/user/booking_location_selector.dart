import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_nova/controllers/bookings/booking_controller.dart';
import 'package:super_nova/controllers/bookings/location_controller.dart';

class BookingLocationSelectorScreen extends StatelessWidget {
  const BookingLocationSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(LocationController());
    // final userProfileController = Get.put(BookingController());
    final userProfileController = Get.find<BookingController>();

    return Scaffold(
      body: Obx(() {
        final currentLocation = locationController.currentLocation.value;
        final selectedLocation = locationController.selectedLocation.value;

        if (currentLocation == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Google Map
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentLocation, zoom: 14),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: locationController.updateSelectedLocation,
              markers: {
                if (selectedLocation != null)
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: selectedLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  ),
              },
            ),

            // Top overlay container
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  // Location display
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(() => Text(
                                locationController.selectedAddress.value,
                                style: const TextStyle(fontSize: 16),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Row with Car & Date
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6)
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.directions_car,
                                  color: Colors.grey),
                              const SizedBox(width: 8),
                              Obx(() => Text(
                                    "${userProfileController.carModel.value}, ${userProfileController.brand.value}",
                                    style: const TextStyle(fontSize: 14),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6)
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.grey, size: 18),
                              SizedBox(width: 8),
                              Text("When?", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Red dot at selected location
            if (selectedLocation != null)
              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         width: 20,
              //         height: 20,
              //         decoration: BoxDecoration(
              //           color: Colors.red,
              //           shape: BoxShape.circle,
              //           border: Border.all(color: Colors.white, width: 2),
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       Container(
              //         width: 60,
              //         height: 60,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: Colors.red.withOpacity(0.2),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Book Now button
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Obx(() {
                  final location = locationController.selectedLocation.value;
                  final address = locationController.selectedAddress.value;
                  final isEnabled = location != null && address.isNotEmpty;

                  return ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                            Get.toNamed('/select-date-time', arguments: {
                              'location': location,
                              'address': address,
                            });
                          }
                        : null, // disables the button
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor:
                          isEnabled ? Colors.blue : Colors.grey, // visual cue
                    ),
                    child: const Text("Book Now",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  );
                }),
              ),
          ],
        );
      }),
    );
  }
}
