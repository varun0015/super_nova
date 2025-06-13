import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:super_nova/controllers/bookings/booking_controller.dart';

import '../../constants/colors.dart';

class BookingOverviewScreen extends StatelessWidget {
  BookingOverviewScreen({super.key});

  // final bookingController = Get.put(BookingController());
  // Get.find<BookingController>();
  final bookingController = Get.find<BookingController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              const Text(
                'Bookings',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                // onTap: () => Get.toNamed('/select-location'),
                onTap: () => Get.toNamed(
                  '/select-location',
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/book_your_car_wash.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          
              const SizedBox(height: 10),
          
              // Active Section
              const Text(
                'Active',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final activeBookings = bookingController.bookings
                    .where((b) => b['status'] == 'active')
                    .toList();
          
                if (activeBookings.isEmpty) {
                  return const Text("No active bookings");
                }
          
                return Column(
                  children: activeBookings.map((booking) {
                    print(booking);
                    final DateTime rawDate = DateTime.parse(booking['date']);
                    final formattedDate = DateFormat('d MMMM y').format(rawDate);
                    final formattedTime = booking['time'];
          
                    final dateTimeDisplay = "$formattedDate - $formattedTime";
                    return BookingCard(
                      bookingId: booking['bookingId'],
                      staffName: "K GANESH", // Static
                      dateTime: dateTimeDisplay,
                      imageUrl: "assets/booking.png",
                      icon: Icons.camera_alt_outlined,
                      iconColor: Colors.amber,
                    );
                  }).toList(),
                );
              }),
          
              const SizedBox(height: 20),
          
              // Completed Section
              const Text(
                'Completed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() {
                log("Rebuilding ACTIVE bookings UI..."); // Add this line
                final completedBookings = bookingController.bookings
                    .where((b) => b['status'] == 'completed')
                    .toList();
          
                if (completedBookings.isEmpty) {
                  return const Text("No completed bookings");
                }
          
                return Column(
                  children: completedBookings.map((booking) {
                    return BookingCard(
                      bookingId: booking['bookingId'],
                      staffName: "K GANESH", // Static
                      dateTime:
                          "${booking['date'].toString().replaceAll(' ', '-')}"
                          " - ${booking['time']}",
                      imageUrl: "assets/booking.png",
                      icon: Icons.check_circle,
                      iconColor: Colors.blue,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String bookingId;
  final String staffName;
  final String dateTime;
  final String imageUrl;
  final IconData icon;
  final Color iconColor;

  const BookingCard({
    super.key,
    required this.bookingId,
    required this.staffName,
    required this.dateTime,
    required this.imageUrl,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text("Booking ID : $bookingId"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Staff Assigned : $staffName"),
            const SizedBox(height: 4),
            Text(
              dateTime,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(icon, color: iconColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
