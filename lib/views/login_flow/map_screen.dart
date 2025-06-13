import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_nova/controllers/login_flow/user_location_controller.dart';


class MapScreen extends StatelessWidget {
  final controller = Get.find<UserLocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.pickedLocation.value,
                zoom: 15,
              ),
              onMapCreated: (mapController) {
                controller.setMapController(mapController);
                controller.getCurrentLocation(); // Auto fetch once
              },
              onCameraMove: (pos) {
                controller.onCameraMove(pos.target);
              },
              onCameraIdle: () {
                controller.reverseGeocode(controller.pickedLocation.value);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: controller.placeName.value),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset("assets/icon_marker.png", height: 40),
            ),
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      controller.placeName.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: controller.onSetLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text("Set Location", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: FloatingActionButton(
                onPressed: controller.getCurrentLocation,
                backgroundColor: Colors.white,
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ])),
    );
  }
}




// class MapScreen extends StatelessWidget {
//   MapScreen({super.key,});

//   final controller = Get.find<UserLocationController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() => Stack(children: [
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: controller.pickedLocation.value,
//                 zoom: 15,
//               ),
//               onMapCreated: (controller) {
//                 this.controller.setMapController(controller);
//                 // if (useCurrent) {
//                 //   this
//                 //       .controller
//                 //       .getCurrentLocation(); // Call AFTER controller is set
//                 // } else {
//                 this
//                     .controller
//                     .reverseGeocode(this.controller.pickedLocation.value);
//                 // }
//               },
//               onCameraMove: (pos) => controller.reverseGeocode(pos.target),
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               onCameraIdle: () {
//                 controller.reverseGeocode(controller.pickedLocation.value);
//               },
//             ),
//             Positioned(
//               top: 50,
//               left: 20,
//               right: 20,
//               child: Obx(
//                 () => Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: const [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     readOnly: true,
//                     controller:
//                         TextEditingController(text: controller.placeName.value),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       prefixIcon: Icon(Icons.location_pin),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Center(
//               child: Image.asset("assets/icon_marker.png", height: 40),
//             ),
//             Positioned(
//               bottom: 160,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       controller.placeName.value,
//                       style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton.icon(
//                       onPressed: () => controller.onSetLocation(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30)),
//                       ),
//                       icon: const Icon(
//                         Icons.check,
//                         color: AppColors.white,
//                       ),
//                       label: const Text(
//                         "Set Location",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               right: 20,
//               child: FloatingActionButton(
//                 onPressed: controller.getCurrentLocation,
//                 backgroundColor: Colors.white,
//                 child: const Icon(Icons.my_location, color: Colors.blue),
//               ),
//             ),
//           ])),
//     );
//   }
// }
