import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:super_nova/constants/colors.dart';
import 'package:super_nova/constants/styles.dart';
import 'package:super_nova/controllers/bookings/booking_controller.dart';
import 'package:super_nova/db/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ConfirmBookingScreen extends StatelessWidget {
  ConfirmBookingScreen({super.key});
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final location = arguments['location'];
    final dateTimeStr = arguments['dateTime'];
    final address = arguments['address'];

    final splitDateTime = dateTimeStr.split(' ');
    final datePart = splitDateTime[0];
    final timePart = splitDateTime[1];

    final dateSegments = datePart.split('-');
    final year = dateSegments[0];
    final month = dateSegments[1].padLeft(2, '0');
    final day = dateSegments[2].padLeft(2, '0');

    final parsedDate = DateTime.parse("$year-$month-$day");

    final formattedDate = DateFormat('EEEE, MMMM d').format(parsedDate);

    // final userProfileController = Get.put(BookingController());
    final userProfileController = Get.find<BookingController>();
    final carModel = userProfileController.carModel.value;
    final carNumber = userProfileController.brand.value;
    final userDetails = userProfileController.userDetails;
    // print(userDetails);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Confirm Booking",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange),
            ),
            const SizedBox(height: 24),

            // Date & Time
            const Text(
              "Date & Time",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            Text(formattedDate, style: headingStyle),
            Text(timePart, style: subTextStyle),
            const Divider(height: 32),

            // Car Wash Info
            const Text("Car Wash", style: TextStyle(color: Colors.grey)),
            Text("$carModel ($carNumber)", style: headingStyle),
            if (userDetails != null) ...[
              const SizedBox(height: 8),
              Text("(${userDetails['vehicle']})", style: subTextStyle),
            ],
            const Divider(height: 32),

            // Address
            const Text("Address", style: TextStyle(color: Colors.grey)),
            const Text("Home", style: headingStyle),
            Text(address,
                style: subTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const Divider(height: 32),

            // Subscription Plan (Static)
            const Text("Subscription Plan",
                style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                Image.asset('assets/subscription_1.png',
                    height: 48), // Replace with your asset
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Monthly Package",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("2 Remaining Washes"),
                    Text("17 Days left", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),

            // Washing Services (Static)
            const Text("Washing Services",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
                "Exterior Hand Wash\nFoam Wash\nInterior Deep Cleaning\nWax & Polish"),
            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final bookingId = const Uuid().v4();

                  final bookingData = {
                    'bookingId': bookingId,
                    'status': 'active',
                    'carModel': carModel,
                    'carNumber': carNumber,
                    'date': parsedDate.toIso8601String(),
                    'time': timePart,
                    'address': address,
                    'location': {
                      'lat': location.latitude,
                      'lng': location.longitude,
                    },
                    'subscription': {
                      'name': 'Monthly Package',
                      'remainingWashes': 2,
                      'daysLeft': 17,
                    },
                    'washingServices': [
                      'Exterior Hand Wash',
                      'Foam Wash',
                      'Interior Deep Cleaning',
                      'Wax & Polish',
                    ],
                    'createdAt': DateTime.now().toIso8601String(),
                  };

                  await firestoreService.addBookingToUser(bookingData);

                  // Get.toNamed('/booking-success', arguments: bookingId);
                  Get.toNamed('/booking-success', arguments: bookingId)?.then((_) {
                    userProfileController
                        .fetchBookings(); // ✅ Refresh on return
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 16, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
