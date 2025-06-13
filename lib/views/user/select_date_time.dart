import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:super_nova/constants/colors.dart';
import 'package:super_nova/controllers/bookings/time_slot_controller.dart';

String cleanTime(String input) {
  return input
      .replaceAll('\u202F', ' ')
      .replaceAll('\u00A0', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

class SelectDateTimeScreen extends StatefulWidget {
  const SelectDateTimeScreen({super.key});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime _selectedDate = DateTime.now();

  final List<String> _timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
  ].map(cleanTime).toList();

  final TimeSlotController timeSlotController = Get.put(TimeSlotController());

  @override
  Widget build(BuildContext context) {
    final location = Get.arguments['location'];
    final address = Get.arguments['address'];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: const BackButton(),
        title: const Text("Select Date & Time"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Calendar
            CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: (newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),

            const SizedBox(height: 16),
            const Text("Available Time",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            /// Reactive Time Slot Chips
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _timeSlots.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final time = _timeSlots[index];

                  return Obx(() {
                    final isSelected =
                        time == timeSlotController.selectedTime.value;
                    return ChoiceChip(
                      label: Text(time),
                      selected: isSelected,
                      onSelected: (_) => timeSlotController.selectTime(time),
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      checkmarkColor: isSelected ? AppColors.white : null,
                    );
                  });
                },
              ),
            ),

            const Spacer(),

            /// Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final selectedTime = timeSlotController.selectedTime.value;
                  print(selectedTime);
                  print(_selectedDate);

                  if (selectedTime.isEmpty) {
                    Get.snackbar("Select Time", "Please select a time slot");
                    return;
                  }

                  try {
                    final sanitizedTime = cleanTime(selectedTime);
                    debugPrint("Selected time (sanitized): '$sanitizedTime'");

                    final formattedDateTime =
                        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day} ${sanitizedTime.replaceAll(' ', '')}";

                    Get.toNamed('/confirm-booking', arguments: {
                      'location': location,
                      'address': address,
                      'dateTime': formattedDateTime,
                    });
                  } catch (e) {
                    Get.snackbar("Time Format Error",
                        "Failed to parse time: $selectedTime");
                    debugPrint('Time parsing error: $e');
                  }
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
