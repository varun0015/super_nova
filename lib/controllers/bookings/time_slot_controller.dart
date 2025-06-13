import 'package:get/get.dart';

class TimeSlotController extends GetxController {
  var selectedTime = ''.obs;

  void selectTime(String time) {
    selectedTime.value = time;
  }
}
