import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/constants/colors.dart';
import 'package:super_nova/views/user/booking_overview_screen.dart';
import 'package:super_nova/views/user/user_profile_screen.dart';
import 'package:super_nova/views/user/user_subscription_screen.dart';

final _db = FirebaseFirestore.instance;

class Userdashboard extends StatefulWidget {
  const Userdashboard({super.key});

  @override
  State<Userdashboard> createState() => _UserdashboardState();
}

class _UserdashboardState extends State<Userdashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // All bottom nav screens in order
    final List<Widget> pages = [
      const HomeScreen(),
      BookingOverviewScreen(),
      UserSubscriptionScreen(),
      UserProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      // body: pages[currentIndex],
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      // body: currentIndex == 0
      //     ? const HomeScreen()
      //     : currentIndex == 1
      //         ? BookingOverviewScreen()
      //         : currentIndex == 2
      //             ? UserSubscriptionScreen() : currentIndex == 3 ? UserProfileScreen()
      //             : Center(child: Text("Page $currentIndex")),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: AppColors.activeButton), 
        unselectedLabelStyle: const TextStyle(color: Colors.grey), 
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions), label: 'Subscription'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String place = '';
  String area = '';
  String brand = '';
  String carModel = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    fetchUserProfileData();
  }

  Future<void> fetchUserProfileData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await _db.collection('users').doc(uid).get();
        final data = doc.data();
        // print(data);

        if (data != null) {
          final location = data['location'] ?? {};
          final carDetials = data['carDetails'] ?? {};

          setState(() {
            place = location['name'] ?? 'Unknown Place';
            area = location['area'] ?? 'Unknown Area';
            city = location['city'] ?? 'Unknown City';
            brand = carDetials['brand'] ?? 'Unknown Brand';
            carModel = carDetials['car'] ?? 'Unknown Car';
          });
        }
      }
    } catch (e) {
      Get.snackbar("Error fetching user profile data: ", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.amber),
                const SizedBox(width: 6),

                // Location info (Expanded so it wraps nicely)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        '$place, $city',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),

                // Car Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      carModel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      brand,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                const Icon(Icons.local_taxi, color: Colors.amber),
              ],
            ),

            // Row(
            //   children: [
            //     const Icon(Icons.location_on, color: Colors.amber),
            //     Text(
            //       'Your location\n$place,$city.',
            //       style: const TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //         color: AppColors.black,
            //       ),
            //     ),
            //     const Spacer(),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text(carModel,
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 color: AppColors.black)),
            //         Text(brand, style: const TextStyle(fontSize: 12)),
            //       ],
            //     ),
            //     const Icon(Icons.local_taxi, color: Colors.amber),
            //     const SizedBox(width: 6),
            //   ],
            // ),
            const SizedBox(height: 20),
            // Keep rest of your code unchanged ↓
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/premium_banner.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // const Positioned(
                  //   left: 16,
                  //   bottom: 16,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text("Supernova Auto Glow",
                  //           style:
                  //               TextStyle(color: Colors.white, fontSize: 14)),
                  //       Text("Premium Car\nDetailing Service",
                  //           style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.bold)),
                  //       Text("Get ₹100 off on your first wash",
                  //           style: TextStyle(color: Colors.amber, fontSize: 14))
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Doorstep Services",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("See all >", style: TextStyle(color: Colors.grey))
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                _serviceTile(
                    "Exterior Hand Wash", 12, 'assets/doorstep_srv1.png'),
                const SizedBox(width: 12),
                _serviceTile("Foam Wash", 531, 'assets/doorstep_srv2.png'),
              ],
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                    image: AssetImage('assets/book_your_car_wash.png'),
                    fit: BoxFit.fill),
              ),
              child: const Row(
                children: [
                  // SizedBox(width: 12),
                  // Expanded(
                  //   child: Text("Book your\nCar wash\nWe near you",
                  //       style: TextStyle(color: Colors.white, fontSize: 16)),
                  // ),
                  // Icon(Icons.check_circle, color: Colors.amber, size: 28)
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Our Subscription",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("See all >", style: TextStyle(color: Colors.grey))
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                _subscriptionTile(
                    "Monthly Plan", "₹XX69", 4, 'assets/subscription_1.png'),
                const SizedBox(width: 12),
                _subscriptionTile(
                    "Quarterly Plan", "₹XX99", 12, 'assets/subscription_2.png'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _serviceTile(String title, int rating, String img) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(img, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Row(children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text("$rating")
            ])
          ],
        ),
      );

  Widget _subscriptionTile(
          String title, String price, int washes, String img) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(img, height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("Subscribe Now",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(children: [
                const Icon(Icons.local_offer, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(price,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
              Row(children: [
                const Icon(Icons.local_taxi, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text("$washes washes")
              ])
            ],
          ),
        ),
      );
}
