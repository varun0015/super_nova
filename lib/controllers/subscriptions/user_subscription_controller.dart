import 'package:get/get.dart';
import 'package:super_nova/db/firestore_service.dart';


class SubscriptionController extends GetxController {
  final selectedPlan = ''.obs;
  final selectedDate = Rxn<DateTime>();
  final currentPlan = ''.obs;
  final currentStartDate = Rxn<DateTime>();
  final firestoreService = FirestoreService();

  // New values to store
  final totalWashes = 0.obs;
  final remainingWashes = 0.obs;
  final planAmount = ''.obs;
  final daysLeft = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentSubscription();
  }

  void selectPlan(String plan) {
    selectedPlan.value = plan;
    selectedDate.value = DateTime.now();
  }

  int getRemainingDays(String plan) {
    if (currentStartDate.value == null || currentPlan.value != plan) return 0;

    final now = DateTime.now();
    Duration duration;
    switch (plan) {
      case 'Monthly':
        duration = const Duration(days: 30);
        break;
      case 'Quarterly':
        duration = const Duration(days: 90);
        break;
      case 'Yearly':
        duration = const Duration(days: 365);
        break;
      default:
        duration = const Duration(days: 0);
    }

    final endDate = currentStartDate.value!.add(duration);
    final remaining = endDate.difference(now).inDays;
    daysLeft.value = remaining;
    return remaining;
  }

  Future<void> confirmSubscription() async {
    if (selectedPlan.value.isEmpty || selectedDate.value == null) return;

    int duration;
    int washes;
    String amount;

    switch (selectedPlan.value) {
      case 'Monthly':
        duration = 30;
        washes = 4;
        amount = '₹XXX/month';
        break;
      case 'Quarterly':
        duration = 90;
        washes = 12;
        amount = '₹XXX/quarter';
        break;
      case 'Yearly':
        duration = 365;
        washes = 48;
        amount = '₹XXX/year';
        break;
      default:
        duration = 0;
        washes = 0;
        amount = '₹0';
    }

    final start = selectedDate.value!;
    final end = start.add(Duration(days: duration));
    final daysRemaining = end.difference(DateTime.now()).inDays;

    await firestoreService.saveUserSubscription({
      'plan': selectedPlan.value,
      'startDate': start.toIso8601String(),
      'durationDays': duration,
      'totalWashes': washes,
      'remainingWashes': washes,
      'amount': amount,
      'daysLeft': daysRemaining,
    });

    // Update local reactive variables
    currentPlan.value = selectedPlan.value;
    currentStartDate.value = start;
    totalWashes.value = washes;
    remainingWashes.value = washes;
    planAmount.value = amount;
    daysLeft.value = daysRemaining;

    // Reset UI selection
    selectedPlan.value = '';
    selectedDate.value = null;

    Get.snackbar("Success", "${currentPlan.value} plan activated!",
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> fetchCurrentSubscription() async {
    final data = await firestoreService.getUserSubscription();
    if (data != null) {
      currentPlan.value = data['plan'];
      currentStartDate.value = DateTime.tryParse(data['startDate']);

      // Fetch additional values
      totalWashes.value = data['totalWashes'] ?? 0;
      remainingWashes.value = data['remainingWashes'] ?? 0;
      planAmount.value = data['amount'] ?? '';
      daysLeft.value = data['daysLeft'] ?? 0;
    }
  }
}


// class SubscriptionController extends GetxController {
//   final selectedPlan = ''.obs;
//   final selectedDate = Rxn<DateTime>();
//   final currentPlan = ''.obs;
//   final currentStartDate = Rxn<DateTime>();
//   final firestoreService = FirestoreService();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchCurrentSubscription();
//   }

//   void selectPlan(String plan) {
//     selectedPlan.value = plan;
//     selectedDate.value = DateTime.now();
//   }

//   int getRemainingDays(String plan) {
//     if (currentStartDate.value == null || currentPlan.value != plan) return 0;

//     final now = DateTime.now();
//     Duration duration;
//     switch (plan) {
//       case 'Monthly':
//         duration = const Duration(days: 30);
//         break;
//       case 'Quarterly':
//         duration = const Duration(days: 90);
//         break;
//       case 'Yearly':
//         duration = const Duration(days: 365);
//         break;
//       default:
//         duration = const Duration(days: 0);
//     }

//     final endDate = currentStartDate.value!.add(duration);
//     return endDate.difference(now).inDays;
//   }

//   Future<void> confirmSubscription() async {
//     if (selectedPlan.value.isEmpty || selectedDate.value == null) return;

//     int duration;
//     switch (selectedPlan.value) {
//       case 'Monthly':
//         duration = 30;
//         break;
//       case 'Quarterly':
//         duration = 90;
//         break;
//       case 'Yearly':
//         duration = 365;
//         break;
//       default:
//         duration = 0;
//     }

//     await firestoreService.saveUserSubscription({
//       'plan': selectedPlan.value,
//       'startDate': selectedDate.value!.toIso8601String(),
//       'durationDays': duration,
//     });

//     currentPlan.value = selectedPlan.value;
//     currentStartDate.value = selectedDate.value;

//     selectedPlan.value = ''; // reset UI selection
//     selectedDate.value = null;

//     Get.snackbar("Success", "${currentPlan.value} plan activated!",
//         snackPosition: SnackPosition.BOTTOM);
//   }

//   Future<void> fetchCurrentSubscription() async {
//     final data = await firestoreService.getUserSubscription();
//     if (data != null) {
//       currentPlan.value = data['plan'];
//       currentStartDate.value = DateTime.tryParse(data['startDate']);
//     }
//   }
// }
