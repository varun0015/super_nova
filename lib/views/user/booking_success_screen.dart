import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/constants/colors.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/booking-success.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo
                Image.asset(
                  'assets/super_nova_logo.png', // Replace with your logo asset
                  height: 60,
                ),
                const Spacer(),
                // Trophy icon
                const CircleAvatar(
                  backgroundColor: Colors.lightBlue,
                  radius: 40,
                  child:
                      Icon(Icons.emoji_events, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Success text
                const Text(
                  "Booking\nSuccessfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Booking confirmed! We’ll take care of your car shortly.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const Spacer(),
                // Done Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.offAllNamed(
                            '/user-dashboard',);
                    //         arguments: {
                    //   'location': location,
                    //   'address': address,
                    //   'dateTime': formattedDateTime,
                    // } // Replace with your route
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
