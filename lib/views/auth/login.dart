import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../controllers/auth/auth_controller.dart';
import 'forgot-password.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool rememberMe = false.obs;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Obx(() {
            final isLoading = AuthController.instance.isLoading.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.05),
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Log in to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                TextFormField(
                  controller: emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  enabled: !isLoading,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),

                // Remember me & Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Row(
                          children: [
                            Checkbox(
                              value: rememberMe.value,
                              onChanged: isLoading
                                  ? null
                                  : (value) =>
                                      rememberMe.value = value ?? false,
                            ),
                            const Text('Remember me'),
                          ],
                        )),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen()),
                              ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                // Login Button
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          AuthController.instance.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0184D2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Log In',
                          style:
                              TextStyle(fontSize: 18, color: AppColors.white),
                        ),
                ),

                SizedBox(height: screenHeight * 0.2),

                // Sign up redirect
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account?',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed('/signup');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            );
          }),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   return Scaffold(
  //     backgroundColor: const Color(0xffF5F5F5),
  //     body: SafeArea(
  //       child: SingleChildScrollView(
  //         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             SizedBox(height: screenHeight * 0.05),
  //             const Text(
  //               'Welcome back!',
  //               style: TextStyle(
  //                 fontSize: 36,
  //                 fontWeight: FontWeight.w700,
  //                 color: AppColors.primary,
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             const Text(
  //               'Log in to continue',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //             SizedBox(height: screenHeight * 0.05),
  //             TextFormField(
  //               controller: emailController,
  //               keyboardType: TextInputType.emailAddress,
  //               decoration: const InputDecoration(
  //                 labelText: 'Email ID',
  //                 border: OutlineInputBorder(),
  //                 prefixIcon: Icon(Icons.email),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             TextField(
  //               controller: passwordController,
  //               obscureText: true,
  //               decoration: const InputDecoration(
  //                 labelText: 'Password',
  //                 border: OutlineInputBorder(),
  //                 prefixIcon: Icon(Icons.lock),
  //               ),
  //             ),
  //             const SizedBox(height: 30),
  //             // Remember me & Forgot password row
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Checkbox(
  //                       value: _rememberMe,
  //                       onChanged: (value) {
  //                         // setState(() {
  //                         //   _rememberMe = value ?? false;
  //                         // });
  //                       },
  //                     ),
  //                     const Text('Remember me'),
  //                   ],
  //                 ),
  //                 TextButton(
  //                   onPressed: () => Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => const ForgotPasswordScreen()),
  //                   ),
  //                   child: const Text(
  //                     'Forgot Password?',
  //                     style: TextStyle(
  //                       color: AppColors.textSecondary,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             ElevatedButton(
  //               onPressed: AuthController.instance.isLoading.value
  //                   ? null
  //                   : () {
  //                       AuthController.instance.login(
  //                         emailController.text.trim(),
  //                         passwordController.text.trim(),
  //                       );
  //                     },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFF0184D2),
  //                 padding: const EdgeInsets.symmetric(vertical: 14),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //               ),
  //               child: AuthController.instance.isLoading.value
  //                   ? const CircularProgressIndicator(color: Colors.white)
  //                   : const Text(
  //                       'Log In',
  //                       style: TextStyle(fontSize: 18, color: AppColors.white),
  //                     ),
  //             ),
  //             SizedBox(
  //               height: screenHeight * 0.2,
  //             ),
  //             Center(
  //               child: Text.rich(
  //                 TextSpan(
  //                   text: 'Don’t have an account?',
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w400,
  //                     color: AppColors.textSecondary,
  //                   ),
  //                   children: [
  //                     const TextSpan(text: ' '),
  //                     TextSpan(
  //                       text: 'Sign Up',
  //                       style: const TextStyle(
  //                         color: AppColors.black,
  //                         fontSize: 17,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                       recognizer: TapGestureRecognizer()
  //                         ..onTap = () {
  //                           Get.toNamed(
  //                               '/signup'); // 👈 Navigate to signup screen
  //                         },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: screenHeight * 0.1,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
