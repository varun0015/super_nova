import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboardController extends GetxController {
  var place = ''.obs;
  var city = ''.obs;
  var area = ''.obs;

  var totalBookings = 0.obs;
  var activeStaff = 0.obs;
  var pendingWashes = 0.obs;
  var absentStaff = 0.obs;

  final _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAdminData();
  }

  Future<void> fetchAdminData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await _db.collection('users').doc(uid).get();
        final data = doc.data();

        if (data != null) {
          final location = data['location'] ?? {};
          place.value = location['name'] ?? 'Unknown Place';
          city.value = location['city'] ?? 'Unknown City';
          area.value = location['area'] ?? 'Unknown Area';
        }
      }

      // Fetch dynamic stats
      // final statsDoc = await _db.collection('dashboardStats').doc('today').get();
      // final stats = statsDoc.data();
      // if (stats != null) {
      //   totalBookings.value = stats['totalBookings'] ?? 0;
      //   activeStaff.value = stats['activeStaff'] ?? 0;
      //   pendingWashes.value = stats['pendingWashes'] ?? 0;
      //   absentStaff.value = stats['absentStaff'] ?? 0;
      // }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
