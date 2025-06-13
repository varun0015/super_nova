import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_nova/controllers/bookings/booking_controller.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onReady() {
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future<String?> getUserRole(String uid) async {
    final userData = await _db.collection('users').doc(uid).get();
    return userData.data()?['role'];
  }

  _setInitialScreen(User? user) async {
    //     if (user != null) {
    //   final role = await getUserRole(user.uid);
    //   if (role == 'user' && !Get.isRegistered<BookingController>()) {
    //     Get.put(BookingController(), permanent: true);
    //   }
    // }

    // if (user == null) {
    //   Get.offAllNamed('/login');
    // } else {
    //   final userData = await _db.collection('users').doc(user.uid).get();
    //   final role = userData.data()?['role'] ?? 'user';

    //   switch (role) {
    //     case 'admin':
    //       Get.offAllNamed('/admin');
    //       break;
    //     case 'staff':
    //       Get.offAllNamed('/staff');
    //       break;
    //     default:
    //     Get.offAllNamed('/user-dashboard');
    //   }
    // }
  }

  Future<void> register(
    String email,
    String password,
    String role,
    String name,
    String mobile,
    File? profilePic, // Optional, but ignored
  ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      // print("Creating user with email: $email");

      // Step 1: Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Save user to Firestore
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email,
        'role': role,
        'name': name,
        'mobile': mobile,
        'profileImage': '', // empty string for now
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("User registered and saved to Firestore: ", cred.user!.uid,
          snackPosition: SnackPosition.BOTTOM);

      // Step 3: Redirect to login
      Get.offAllNamed('/login');
    } catch (e) {
      // print("Registration Error: $e");
      Get.snackbar("Registration Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final uid = _auth.currentUser!.uid;
      // You can navigate or listen to authStateChanges

      // After login, check if user has completed onboarding flow
      // final prefs = await SharedPreferences.getInstance();
      // final hasCompletedFlow = prefs.getBool('completed_user_flow') ?? false;

      // Fetch role from Firestore
      final userDoc = await _db.collection('users').doc(uid).get();
      final role = userDoc.data()?['role'] ?? 'user';

      final prefs = await SharedPreferences.getInstance();

      final hasCompletedFlow = prefs.getBool('completed_user_flow') ?? false;
      if (role == 'user') {
        if (hasCompletedFlow) {
          Get.offAllNamed('/user-dashboard');
          Get.put(BookingController(), permanent: true);
        } else {
          Get.offAllNamed('/location');
          Get.put(BookingController(), permanent: true);
        }
      } else if (role == 'admin') {
        if (hasCompletedFlow) {
          Get.offAllNamed('/admin-dashboard');
        } else {
          Get.offAllNamed('/location');
        }
      } else if (role == 'staff') {
        if (hasCompletedFlow) {
          Get.offAllNamed('/staff-dashboard');
        } else {
          Get.offAllNamed('/location');
        }
      } else {
        Get.snackbar('Login Error', 'Unknown role: $role',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('seen_intro');
    await prefs.remove('completed_user_flow');
    Get.offAllNamed('/login');
    await _auth.signOut();
  }

  // void login(String email, String password) async {
  //   if (isLoading.value) return; // prevent double tap

  //   isLoading.value = true;

  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     // _setInitialScreen will be triggered by authStateChanges
  //   } catch (e) {
  //     Get.snackbar('Login Failed', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // void register(String email, String password, String role) async {
  //   try {
  //     final result = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     await _db.collection('users').doc(result.user!.uid).set({
  //       'email': email,
  //       'role': role,
  //     });
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

  //   Future<void> register(
  //   String email,
  //   String password,
  //   String role,
  //   String name,
  //   String mobile,
  //   File? profilePic,
  // ) async {
  //   try {
  //     UserCredential cred = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     String? imageUrl;
  //     if (profilePic != null) {
  //       final ref = _storage
  //           .ref()
  //           .child("profile_pics")
  //           .child("${cred.user!.uid}.jpg");
  //       await ref.putFile(profilePic);
  //       imageUrl = await ref.getDownloadURL();
  //     }

  //     await _db.collection('users').doc(cred.user!.uid).set({
  //       'uid': cred.user!.uid,
  //       'email': email,
  //       'role': role,
  //       'name': name,
  //       'mobile': mobile,
  //       'profileImage': imageUrl ?? '',
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });

  //     Get.offAllNamed('/login');
  //   } catch (e) {
  //     Get.snackbar("Registration Error", e.toString(),
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  // void login(String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //   } catch (e) {
  //     Get.snackbar('Login Failed', e.toString());
  //   }
  // }
}
