import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("App state changed to: $state");

    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      // App is killed or closed
      _handleAppKilled();
    }
  }

  void _handleAppKilled() {
    // Log the user out
    // FirebaseAuth.instance.signOut();
    // Optionally clear local data too
    // Get.offAllNamed('/login'); // or wherever your login route is
  }
}
