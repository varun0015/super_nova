import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onChangePassword() {
    // Navigate or show dialog
    log("Change Password tapped");
  }

  void onNotifications() {
    // Navigate or toggle
    log("Notifications tapped");
  }

  void onPrivacySettings() {
    // Navigate to privacy settings
    log("Privacy Settings tapped");
  }

 void onSignOut() async {
    log("Sign Out tapped");

    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.remove('seen_intro');
      // await prefs.remove('completed_user_flow');
      await _auth.signOut();

      Get.offAllNamed('/login');
    } catch (e) {
      log("Error during sign out: $e");
      Get.snackbar("Error", "Failed to sign out. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close loading dialog
      }
    }
  }
}
