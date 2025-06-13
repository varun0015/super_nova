import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:super_nova/constants/colors.dart';
import 'package:super_nova/controllers/admin/admin_dashboard_controller.dart';

// ignore: must_be_immutable
class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AdminDashboard(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColors.white,
        // currentIndex: currentIndex,
        // onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: AppColors.activeButton),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Staffs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt), label: 'Customer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDashboardController());

    final today = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(today);
    final dayOfWeek = DateFormat('EEEE').format(today);

    // var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 120) / 2;
    // final double itemWidth = size.width / 2;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location and Date Row
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.orange),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${controller.place.value}, ${controller.city.value}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow:
                                TextOverflow.ellipsis, // handle long names
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     const Icon(Icons.location_pin, color: Colors.orange),
                  //     const SizedBox(width: 4),
                  //     Text(
                  //       '${controller.place.value}, ${controller.city.value}',
                  //       style: const TextStyle(fontWeight: FontWeight.w500),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formattedDate,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(dayOfWeek,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Welcome Card
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/admin-welcome-banner.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Overview Section
            const Text(
              'Overview of today',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (150 / 120),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _OverviewCard(
                  title: 'Total Bookings Today',
                  count: '10',
                  color: Color(0xFF3085FE), // background: #3085FE0D
                ),
                _OverviewCard(
                  title: 'Active Staff on Field',
                  count: '8',
                  color: Color(0xFFA3D139), // background: #A3D1390D
                ),
                _OverviewCard(
                  title: 'Pending Washes',
                  count: '4',
                  color: Color(0xFFFEBA00), // #FEBA00
                ),
                _OverviewCard(
                  title: 'Absent Staff',
                  count: '2',
                  color: Color(0xFFFF7F74), // background: #FF7F740D
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Booking Management Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Management',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'See all',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Booking Cards
            const _BookingCard(
              name: 'G YASH (Swift,Maruti Suzuki)',
              date: 'May 28, 2025 – 10:00 AM',
              package: 'Monthly',
              washes: '3/4',
              staff: 'K GANESH',
              status: 'Ongoing',
              statusColor: Colors.blue,
            ),
            const _BookingCard(
              name: 'R Meena (KIA,Seltos)',
              date: 'May 28, 2025 – 10:30 AM',
              package: 'Yearly',
              washes: '12/48',
              staff: 'M RAVI',
              status: 'Arrived',
              statusColor: Colors.orange,
            ),
            const _BookingCard(
              name: 'M GUNA (Volkswagen,Polo)',
              date: 'May 28, 2025 – 10:30 AM',
              package: 'Quarterly',
              washes: '6/12',
              staff: 'M AJITH',
              status: 'Completed',
              statusColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _OverviewCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const Spacer(),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          )
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String name, date, package, washes, staff, status;
  final Color statusColor;

  const _BookingCard({
    required this.name,
    required this.date,
    required this.package,
    required this.washes,
    required this.staff,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Row(
              children: [
                Text('Package: $package'),
                const Spacer(),
                Text('Total Washes: $washes'),
              ],
            ),
            const SizedBox(height: 6),
            Text('Staff Assigned: $staff'),
          ],
        ),
      ),
    );
  }
}


// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AdminDashboardController());

//     final today = DateTime.now();
//     final formattedDate = DateFormat('dd/MM/yyyy').format(today);
//     final dayOfWeek = DateFormat('EEEE').format(today);

//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Location and Date Row
//             Obx(() => Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(Icons.location_pin, color: Colors.orange),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${controller.place.value}, ${controller.city.value}',
//                           style:
//                               const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(formattedDate,
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.w600)),
//                         Text(dayOfWeek,
//                             style: const TextStyle(color: Colors.grey)),
//                       ],
//                     )
//                   ],
//                 )),
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 image: const DecorationImage(
//                   image: AssetImage('assets/admin-welcome-banner.png'),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Overview of today',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const SizedBox(height: 12),

//             // Overview Cards
//             Obx(() => GridView.count(
//                   crossAxisCount: 2,
//                   childAspectRatio: (150 / 120),
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   children: [
//                     _OverviewCard(
//                       title: 'Total Bookings Today',
//                       count: controller.totalBookings.value.toString(),
//                       color: const Color(0xFF3085FE),
//                     ),
//                     _OverviewCard(
//                       title: 'Active Staff on Field',
//                       count: controller.activeStaff.value.toString(),
//                       color: const Color(0xFFA3D139),
//                     ),
//                     _OverviewCard(
//                       title: 'Pending Washes',
//                       count: controller.pendingWashes.value.toString(),
//                       color: const Color(0xFFFEBA00),
//                     ),
//                     _OverviewCard(
//                       title: 'Absent Staff',
//                       count: controller.absentStaff.value.toString(),
//                       color: const Color(0xFFFF7F74),
//                     ),
//                   ],
//                 )),
//             const SizedBox(height: 20),
//             // The rest of your booking cards stay static or you can also make them dynamic here
//           ],
//         ),
//       ),
//     );
//   }
// }

