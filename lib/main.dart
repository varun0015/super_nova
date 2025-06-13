import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_nova/controllers/bookings/booking_controller.dart';
import 'package:super_nova/views/user/user_setting_screen.dart';

import 'controllers/auth/auth_controller.dart';
import 'views/admin/admin_dashboard_screen.dart';
import 'views/intro.dart';
import 'views/auth/login.dart';
import 'views/auth/sign_up.dart';
import 'views/staff/staff_dashboard_screen.dart';
import 'views/user/booking_location_selector.dart';
import 'views/user/booking_overview_screen.dart';
import 'views/user/booking_success_screen.dart';
import 'views/user/brand_cars_screen.dart';
import 'views/user/brand_list_screen.dart';
import 'views/user/confirm_booking_screen.dart';
import 'views/login_flow/location_screen.dart';
import 'views/login_flow/map_screen.dart';
import 'views/user/select_date_time.dart';
import 'views/user/user_dashboard.dart';
import 'views/user/user_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signOut(); // Auto logout on app restart // TODO -- to be removed while giving to QA
  
  final prefs = await SharedPreferences.getInstance();
  //  await prefs.remove('seen_intro');
  // await prefs.remove('completed_user_flow');

  final bool seenIntro = prefs.getBool('seen_intro') ?? false;

  // Only put AuthController if intro is already seen
  if (seenIntro) {
    Get.put(AuthController());
  }

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    // initialRoute: '/',
    home: seenIntro ? const SplashScreen() : const IntroScreen(),
    getPages: [
      // GetPage(name: '/', page: () => const SplashScreen()),
      GetPage(name: '/login', page: () => LoginScreen()),
      GetPage(name: '/signup', page: () => const SignUpScreen()),
      GetPage(name: '/admin-dashboard', page: () => AdminDashboardScreen()),
      GetPage(name: '/staff-dashboard', page: () => StaffDashboardScreen()),
      GetPage(name: '/user-dashboard', page: () => const Userdashboard()),
      GetPage(name: '/location', page: () => LocationScreen()),
      GetPage(name: '/map', page: () => MapScreen()),
      GetPage(name: '/brands', page: () => const BrandListScreen()),
      GetPage(name: '/brand-cars', page: () => BrandCarsScreen()),
      GetPage(
        name: '/user-welcome',
        page: () => const UserInfoScreen(),
      ),
      GetPage(name: '/booking-overview', page: () => BookingOverviewScreen()),
      GetPage(
          name: '/select-location',
          page: () => const BookingLocationSelectorScreen()),
      GetPage(
          name: '/select-date-time', page: () => const SelectDateTimeScreen()),
      GetPage(name: '/confirm-booking', page: () => ConfirmBookingScreen()),
      GetPage(
        name: '/booking-success',
        page: () => const BookingSuccessScreen(),
      ),
      GetPage(
        name: '/user-settings',
        page: () => UserSettingsScreen(),
      ),
    ],
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Short delay

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      try {
        final role = await AuthController.instance.getUserRole(user.uid);
        switch (role) {
          case 'admin':
            Get.offAllNamed('/admin-dashboard');
            break;
          case 'staff':
            Get.offAllNamed('/staff-dashboard');
            break;
          default:
            // Register the BookingController here for users
            // if (role == 'user' && !Get.isRegistered<BookingController>()) {
            //   Get.put(BookingController(), permanent: true);
            // }

            if (!Get.isRegistered<BookingController>()) {
              Get.put(BookingController(), permanent: true);
            }
            Get.offAllNamed('/user-dashboard');
        }
      } catch (e) {
        log('Error getting user role: $e');
        Get.offAllNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image(image: AssetImage('assets/splash_logo.png')),
        ),
      ),
    );
  }
}
