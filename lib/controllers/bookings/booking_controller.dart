// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:super_nova/db/firestore_service.dart';

// class BookingController extends GetxController {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirestoreService firestoreService = FirestoreService();

//   var bookingConfirmed = false.obs;
//   var isLoading = false.obs;

//   var brand = ''.obs;
//   var carModel = ''.obs;

//   var activeBookings = <Map<String, dynamic>>[].obs;
//   var completedBookings = <Map<String, dynamic>>[].obs;
//   Map<String, dynamic>? userDetails;
//   var bookings = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserProfileData();
//     loadUserDetails();
//     fetchBookings();
//   }

//   void loadUserDetails() async {
//     userDetails = await firestoreService.getUserDetails();
//   }

//   Future<void> fetchBookings() async {
//     final firestoreService = FirestoreService();
//     bookings.value = await firestoreService.getUserBookings();
//   }

//   Future<void> fetchUserProfileData() async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid != null) {
//         final doc = await _db.collection('users').doc(uid).get();
//         final data = doc.data();

//         if (data != null) {
//           final carDetails = data['carDetails'] ?? {};
//           brand.value = carDetails['brand'] ?? 'Unknown Brand';
//           carModel.value = carDetails['car'] ?? 'Unknown Car';
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch user profile: $e",
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
// }

//backuppp

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:super_nova/db/firestore_service.dart';

class BookingController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirestoreService firestoreService = FirestoreService();

  var bookingConfirmed = false.obs;
  var isLoading = false.obs;

  var brand = ''.obs;
  var carModel = ''.obs;

  var bookings = <Map<String, dynamic>>[].obs;
  var activeBookings = <Map<String, dynamic>>[].obs;
  var completedBookings = <Map<String, dynamic>>[].obs;

  Map<String, dynamic>? userDetails;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfileData();
    loadUserDetails();
    fetchBookings();
  }

  @override
  void onReady() {
    super.onReady();
    fetchBookings(); // Refresh every time screen becomes active
  }

  /// Load userDetails from FirestoreService and assign to local var
  void loadUserDetails() async {
    userDetails = await firestoreService.getUserDetails();
  }

  /// Fetch all bookings for current user
  // Future<void> fetchBookings() async {
  //   bookings.value = await firestoreService.getUserBookings();
  // }
  Future<void> fetchBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      log("User not logged in. Skipping fetchBookings.");
      return;
    }
    log("Fetching bookings...");
    final newBookings = await firestoreService.getUserBookings();
    log("Fetched bookings: ${newBookings.length}");
    bookings.value = newBookings;
  }

  /// Fetch car brand and model from Firestore
  Future<void> fetchUserProfileData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await _db.collection('users').doc(uid).get();
        final data = doc.data();

        if (data != null) {
          final carDetails = data['carDetails'] ?? {};
          brand.value = carDetails['brand'] ?? 'Unknown Brand';
          carModel.value = carDetails['car'] ?? 'Unknown Car';
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch user profile: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
