import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add this import

class LocationController extends GetxController {
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  RxString selectedAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final latLng = LatLng(position.latitude, position.longitude);
        currentLocation.value = latLng;
        updateSelectedLocation(latLng); // this will also fetch address
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching location: $e");
      }
    }
  }

  void updateSelectedLocation(LatLng pos) async {
    selectedLocation.value = pos;
    selectedAddress.value = 'Fetching address...';

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        selectedAddress.value =
            '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        selectedAddress.value = 'Address not found';
      }
    } catch (e) {
      selectedAddress.value = 'Failed to fetch address';
      if (kDebugMode) {
        print("Reverse geocoding error: $e");
      }
    }

    if (kDebugMode) {
      print("Updated selected location: $pos");
    }
  }
}
