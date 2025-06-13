import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/constants/colors.dart';
import 'package:super_nova/controllers/subscriptions/user_subscription_controller.dart';

class UserSubscriptionScreen extends StatelessWidget {
  final controller = Get.put(SubscriptionController());

  Widget buildPlanCard(String plan, int washes, String price, int duration) {
    return Obx(() {
      final isSelected = controller.selectedPlan.value == plan;
      final isActive = controller.currentPlan.value == plan;
      return GestureDetector(
        onTap: () => controller.selectPlan(plan),
        child: Container(
          // color: isActive ? const Color(0xFF0B4B89) : Colors.white,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0B4B89) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? const Color(0xFF0B4B89) : Colors.grey.shade300,
              width: isActive ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "$plan Package",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isActive ? Colors.white : Colors.black),
                    ),
                    const Spacer(),
                    if (isSelected || isActive)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor:
                            isActive ? Colors.green : Colors.transparent,
                        child: isActive
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                            : Radio<String>(
                                value: plan,
                                groupValue: controller.selectedPlan.value,
                                onChanged: (String? value) {
                                  if (value != null) {
                                    controller.selectPlan(value);
                                  }
                                },
                                activeColor: const Color(0xFF0B4B89),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                      )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "$washes Washes",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isActive ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (controller.selectedPlan.value == plan)
                  const Text("New plan (not confirmed)",
                      style: TextStyle(color: Colors.black87))
                else if (controller.currentPlan.value == plan)
                  Text(
                    "${controller.getRemainingDays(plan)} Days left",
                    style: TextStyle(
                        color:
                            isActive ? Colors.white70 : Colors.grey.shade600),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          final hasCurrentPlan = controller.currentPlan.isNotEmpty;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Subscription',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 40,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text("Current Plan",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                if (!hasCurrentPlan)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No active plan.",
                        style: TextStyle(color: Colors.grey)),
                  ),
                if (hasCurrentPlan)
                  buildPlanCard(
                      controller.currentPlan.value,
                      controller.currentPlan.value == 'Monthly'
                          ? 4
                          : controller.currentPlan.value == 'Quarterly'
                              ? 12
                              : 48,
                      '',
                      0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text("Upgrade Plan",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                // buildPlanCard('Monthly', 4, '₹XXX/month', 30),
                // buildPlanCard('Quarterly', 12, '₹XXX/month', 90),
                // buildPlanCard('Yearly', 48, '₹XXX/month', 365),
                if (controller.currentPlan.value != 'Monthly')
                  buildPlanCard('Monthly', 4, '₹XXX/month', 30),
                if (controller.currentPlan.value != 'Quarterly')
                  buildPlanCard('Quarterly', 12, '₹XXX/month', 90),
                if (controller.currentPlan.value != 'Yearly')
                  buildPlanCard('Yearly', 48, '₹XXX/month', 365),

                if (controller.selectedPlan.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0184D2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: controller.confirmSubscription,
                        child: const Text(
                          "Confirm & Continue",
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
