import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/firestore_service.dart';

// class UserLocationController extends GetxController {
//   final TextEditingController searchController = TextEditingController();
//   // late GoogleMapController mapController;
//   GoogleMapController? mapController;

//   var pickedLocation = const LatLng(12.9716, 77.5946).obs;
//   var placeName = 'Loading...'.obs;
//   var area = ''.obs;
//   var city = ''.obs;
//   var predictions = [].obs;
//   var fullAddress = ''.obs;
//   var currentLocationText = ''.obs;
//   var isLoadingCurrentLocation = false.obs;
//   var hasUserMovedManually = false.obs;

//   void setMapController(GoogleMapController controller) {
//     mapController = controller;
//   }

//   Future<void> getCurrentLocation() async {
//     // Don't proceed if user has already manually moved the map
//     if (hasUserMovedManually.value) return;

//     isLoadingCurrentLocation.value = true;

//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       isLoadingCurrentLocation.value = false;
//       return;
//     }

//     var permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) {
//         isLoadingCurrentLocation.value = false;
//         return;
//       }
//     }

//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     if (!hasUserMovedManually.value) {
//       await updateLocation(LatLng(position.latitude, position.longitude));
//       await reverseGeocode(LatLng(position.latitude, position.longitude));
//       currentLocationText.value =
//           '${placeName.value}, ${area.value}, ${city.value}';
//       print(currentLocationText);
//     }

//     isLoadingCurrentLocation.value = false;
//   }

//   // Future<void> getCurrentLocation() async {
//   //   isLoadingCurrentLocation.value = true;

//   //   final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if (!serviceEnabled) {
//   //     isLoadingCurrentLocation.value = false;
//   //     return;
//   //   }

//   //   var permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.deniedForever) {
//   //       isLoadingCurrentLocation.value = false;
//   //       return;
//   //     }
//   //   }

//   //   final position = await Geolocator.getCurrentPosition(
//   //     desiredAccuracy: LocationAccuracy.high,
//   //   );

//   //   await updateLocation(LatLng(position.latitude, position.longitude));
//   //   await reverseGeocode(LatLng(position.latitude, position.longitude));

//   //   currentLocationText.value =
//   //       '${placeName.value}, ${area.value}, ${city.value}';
//   //   print(currentLocationText);

//   //   isLoadingCurrentLocation.value = false;
//   // }

//   Future<void> updateLocation(LatLng latLng) async {
//     pickedLocation.value = latLng;
//     if (mapController != null) {
//       mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
//     }
//     await reverseGeocode(latLng);
//   }

//   Future<void> reverseGeocode(LatLng latLng) async {
//     final placemarks =
//         await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//     if (placemarks.isNotEmpty) {
//       final place = placemarks.first;
//       placeName.value = place.name ?? '';
//       area.value = place.subLocality ?? '';
//       city.value = place.locality ?? '';
//     }
//   }

//   Future<void> onSetLocation() async {
//     final userLocationData = {
//       'latitude': pickedLocation.value.latitude,
//       'longitude': pickedLocation.value.longitude,
//       'name': placeName.value,
//       'area': area.value,
//       'city': city.value,
//       'full_address': fullAddress.value,
//       'timestamp': FieldValue.serverTimestamp(),
//     };

//     await FirestoreService().saveUserLocation(userLocationData);

//     print(userLocationData);

//     // Get.offAllNamed('/user-welcome');
//   }

//   // Future<void> getCurrentLocation() async {
//   //   final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if (!serviceEnabled) return;

//   //   var permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.deniedForever) return;
//   //   }

//   //   final position = await Geolocator.getCurrentPosition(
//   //       // ignore: deprecated_member_use
//   //       desiredAccuracy: LocationAccuracy.high);

//   //   updateLocation(LatLng(position.latitude, position.longitude));
//   // }

//   // Future<void> onSetLocation() async {
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   if (user == null) return;

//   //   final docRef =
//   //       FirebaseFirestore.instance.collection('user_locations').doc(user.uid);

//   //   final data = {
//   //     'latitude': pickedLocation.value.latitude,
//   //     'longitude': pickedLocation.value.longitude,
//   //     'place_name': placeName.value,
//   //     'area': area.value,
//   //     'city': city.value,
//   //     'full_address': fullAddress.value,
//   //     'timestamp': FieldValue.serverTimestamp(),
//   //   };

//   //   final doc = await docRef.get();
//   //   if (doc.exists) {
//   //     await docRef.update(data);
//   //   } else {
//   //     await docRef.set(data);
//   //   }

//   //   Get.offAllNamed('/user-welcome');
//   // }
// }

//backupppp

class UserLocationController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  GoogleMapController? mapController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var pickedLocation = const LatLng(12.9716, 77.5946).obs;
  var placeName = 'Loading...'.obs;
  var area = ''.obs;
  var city = ''.obs;
  var predictions = [].obs;
  var fullAddress = ''.obs;
  var currentLocationText = ''.obs;
  var isLoadingCurrentLocation = false.obs;

  Timer? _debounceTimer;
  // bool hasFetchedCurrentLocation = false;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocation() async {
    // if (hasFetchedCurrentLocation) return; // only once
    // hasFetchedCurrentLocation = true;

    isLoadingCurrentLocation.value = true;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoadingCurrentLocation.value = false;
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        isLoadingCurrentLocation.value = false;
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final currentLatLng = LatLng(position.latitude, position.longitude);
    await updateLocation(currentLatLng);
    currentLocationText.value =
        '${placeName.value}, ${area.value}, ${city.value}';

    isLoadingCurrentLocation.value = false;
  }

  Future<void> updateLocation(LatLng latLng) async {
    pickedLocation.value = latLng;
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    }
    await reverseGeocode(latLng);
  }

  Future<void> reverseGeocode(LatLng latLng) async {
    final placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      placeName.value = place.name ?? '';
      area.value = place.subLocality ?? '';
      city.value = place.locality ?? '';
    }
  }

  void onCameraMove(LatLng newPosition) {
    pickedLocation.value = newPosition;

    // Debounce reverse geocoding
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      reverseGeocode(newPosition);
    });
  }

  Future<void> onSetLocation() async {
    final mergedAddress = "${placeName.value}, ${area.value}, ${city.value}";
    final userLocationData = {
      'latitude': pickedLocation.value.latitude,
      'longitude': pickedLocation.value.longitude,
      'name': placeName.value,
      'area': area.value,
      'city': city.value,
      'full_address': fullAddress.value.trim().isNotEmpty
          ? fullAddress.value
          : mergedAddress,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirestoreService().saveUserLocation(userLocationData);

    print(userLocationData);

    final uid = _auth.currentUser!.uid;
    final userDoc = await _db.collection('users').doc(uid).get();
    final role = userDoc.data()?['role'] ?? 'user';

    if (role == 'user') {
      Get.offAllNamed('/user-welcome');
    } else if (role == 'admin') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('completed_user_flow', true);
      Get.offAllNamed('/admin-dashboard');
    } else if (role == 'staff') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('completed_user_flow', true);
      Get.offAllNamed('/staff-dashboard');
    }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
