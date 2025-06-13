import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_nova/controllers/auth/auth_controller.dart';

import '../constants/colors.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> bgImages = [
    'assets/intro_1.png',
    'assets/intro_2.jpeg',
    'assets/intro_3.jpeg',
  ];

  final List<String> titles = [
    'Premium Car Care, Right Where You Are',
    'Just Tell Us Where Your Car Is',
    'Relax While We Work Our Magic',
  ];

  final List<String> descriptions = [
    'We clean cars inside gated communities, right at your doorstep.',
    "No extra fees. We come to your car, wherever it's parked.",
    "Enjoy your time while we wash your beloved car until it's finished.",
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// Background Slides
          PageView.builder(
            controller: _controller,
            itemCount: bgImages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => Image.asset(
              bgImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          /// Foreground content with scroll & spacing
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),

                  /// Logo
                  Center(
                    child: Image.asset(
                      'assets/super_nova_logo.png',
                      height: 80,
                    ),
                  ),

                  SizedBox(
                    height: screenHeight * 0.1,
                  ),

                  /// Title
                  Text(
                    titles[_currentIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Description
                  Text(
                    descriptions[_currentIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(bgImages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: _currentIndex == index ? 12 : 8,
                        height: _currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    }),
                  ),

                  const Spacer(),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('seen_intro', true);
                            // Initialize AuthController if not already put
                            if (!Get.isRegistered<AuthController>()) {
                              Get.put(AuthController());
                            }
                            Get.offAllNamed('/login');

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (_) => LoginScreen()),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.activeButton,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Log In',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('seen_intro', true);
                            // if (!Get.isRegistered<AuthController>()) {
                              Get.put(AuthController());
                            // }
                            Get.offAllNamed('/signup');
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (_) => const SignUpScreen()),
                            // );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Sign Up',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Terms & Privacy
                  const Text.rich(
                    TextSpan(
                      text: 'By joining you agree to our ',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         /// Background Slides
  //         PageView.builder(
  //           controller: _controller,
  //           itemCount: bgImages.length,
  //           onPageChanged: (index) => setState(() => _currentIndex = index),
  //           itemBuilder: (context, index) => Image.asset(
  //             bgImages[index],
  //             fit: BoxFit.cover,
  //             width: double.infinity,
  //             height: double.infinity,
  //           ),
  //         ),

  //         /// Logo, Title, Description
  //         Positioned(
  //           top: screenHeight * 0.18,
  //           left: 24,
  //           right: 24,
  //           child: Column(
  //             children: [
  //               Center(
  //                 child: Image.asset(
  //                   'assets/super_nova_logo.png',
  //                   height: 80,
  //                 ),
  //               ),
  //               const SizedBox(height: 102),
  //               Text(
  //                 titles[_currentIndex],
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   fontSize: 36,
  //                   fontWeight: FontWeight.w700,
  //                   color: AppColors.primary,
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Text(
  //                 descriptions[_currentIndex],
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w400,
  //                   color: AppColors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         /// Dots Indicator
  //         Positioned(
  //           top: screenHeight * 0.58,
  //           left: 0,
  //           right: 0,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: List.generate(bgImages.length, (index) {
  //               return AnimatedContainer(
  //                 duration: const Duration(milliseconds: 300),
  //                 margin: const EdgeInsets.symmetric(horizontal: 6),
  //                 width: _currentIndex == index ? 12 : 8,
  //                 height: _currentIndex == index ? 12 : 8,
  //                 decoration: BoxDecoration(
  //                   color: _currentIndex == index
  //                       ? AppColors.white
  //                       : Colors.white54,
  //                   borderRadius: BorderRadius.circular(6),
  //                 ),
  //               );
  //             }),
  //           ),
  //         ),

  //         /// Buttons
  //         Positioned(
  //           top: screenHeight * 0.78,
  //           left: 20,
  //           right: 20,
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: ElevatedButton(
  //                   onPressed: () async {
  //                     final prefs = await SharedPreferences.getInstance();
  //                     await prefs.setBool('seen_intro', true);
  //                     Get.put(AuthController());
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (_) => LoginScreen()),
  //                     );
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.activeButton,
  //                     padding: const EdgeInsets.symmetric(vertical: 14),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                   child: const Text('Log In',
  //                       style: TextStyle(color: Colors.white)),
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: OutlinedButton(
  //                   onPressed: () async {
  //                     final prefs = await SharedPreferences.getInstance();
  //                     await prefs.setBool('seen_intro', true);
  //                     Navigator.push(context,
  //                         MaterialPageRoute(builder: (_) => const SignUpScreen()));
  //                   },
  //                   style: OutlinedButton.styleFrom(
  //                     side: const BorderSide(color: Colors.white),
  //                     padding: const EdgeInsets.symmetric(vertical: 14),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                   child: const Text('Sign Up',
  //                       style: TextStyle(color: Colors.white)),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         /// Terms & Privacy Text
  //         Positioned(
  //           top: screenHeight * 0.88,
  //           left: 20,
  //           right: 20,
  //           child: const Text.rich(
  //             TextSpan(
  //               text: 'By joining you agree to our ',
  //               style: TextStyle(color: Colors.white70, fontSize: 12),
  //               children: [
  //                 TextSpan(
  //                   text: 'Terms of Service',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 TextSpan(text: ' and '),
  //                 TextSpan(
  //                   text: 'Privacy Policy',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
