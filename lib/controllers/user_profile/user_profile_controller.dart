import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

class UserProfileController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhoto = ''.obs;
  var userAddress = ''.obs;
  var plan = ''.obs;
  var washes = 0.obs;
  var remainingWashes = 0.obs;
  var daysLeft = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        userName.value = data['name'] ?? 'Unknown';
        userEmail.value = data['email'] ?? '';
        // userPhoto.value = data['photo'] ?? '';
        userAddress.value = data['location']['full_address'] ?? '';

        final planData = data['subscription'] ?? {};
        plan.value = planData['plan'] ?? 'No Plan';
        washes.value = planData['totalWashes'] ?? 0;
        remainingWashes.value = planData['remainingWashes'] ?? 0;
        daysLeft.value = planData['daysLeft'] ?? 0;
        // amount
      }
    }
  }

  // Future<void> pickAndUploadImage() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     // Upload logic to Firebase Storage and update Firestore with new URL.
  //     userPhoto.value = picked.path; // Temporary for demo purpose
  //   }
  // }
}
