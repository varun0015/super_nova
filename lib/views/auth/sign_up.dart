// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';

// // ignore: use_key_in_widget_constructors
// class SignUpScreen extends StatefulWidget {
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String selectedRole = 'user';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 'Create Account',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: Icon(Icons.lock),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: selectedRole,
//                 onChanged: (value) {
//                   if (value != null) {
//                     setState(() => selectedRole = value);
//                   }
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Role',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['user', 'admin', 'staff']
//                     .map((role) => DropdownMenuItem(
//                           value: role,
//                           child: Text(role.capitalize!),
//                         ))
//                     .toList(),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   AuthController.instance.register(
//                     emailController.text.trim(),
//                     passwordController.text.trim(),
//                     selectedRole,
//                   );
//                 },
//                 style:
//                     ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
//                 child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 child: const Text('Already have an account? Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_nova/constants/colors.dart';
import '../../controllers/auth/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'user';

  void _signUp() {
    if (AuthController.instance.isLoading.value) return;

    AuthController.instance.register(
      emailController.text.trim(),
      passwordController.text.trim(),
      selectedRole,
      nameController.text.trim(),
      mobileController.text.trim(),
      null, // profilePic is null for now
    );
  }

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
                const Text(
                  'Welcome Friend!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sign up to join',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => selectedRole = value);
                          }
                        },
                  decoration: const InputDecoration(
                    labelText: 'Select Role',
                    border: OutlineInputBorder(),
                  ),
                  items: ['user', 'admin', 'staff']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.capitalize!),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0184D2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Sign Up',
                          style:
                              TextStyle(fontSize: 18, color: AppColors.white),
                        ),
                ),
                SizedBox(height: screenHeight * 0.2),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account?',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (!Get.isRegistered<AuthController>()) {
                                Get.put(AuthController());
                              }
                              Get.toNamed('/login');
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
}


// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final picker = ImagePicker();
//   // File? _pickedImage;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String selectedRole = 'user';

//   // Future<void> _pickImage() async {
//   //   final pickedFile =
//   //       await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _pickedImage = File(pickedFile.path);
//   //     });
//   //   }
//   // }

//   void _signUp() {
//     AuthController.instance.register(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//         selectedRole,
//         nameController.text.trim(),
//         mobileController.text.trim(),
//         // _pickedImage,
//         null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 'Welcome Friend!',
//                 style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.primary),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Sign up to join',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               // Profile Image Picker
//               // Center(
//               //   child: GestureDetector(
//               //     onTap: _pickImage,
//               //     child: CircleAvatar(
//               //       radius: 50,
//               //       backgroundImage: _pickedImage != null
//               //           ? FileImage(_pickedImage!)
//               //           : const AssetImage("assets/icon_marker.png")
//               //               as ImageProvider,
//               //       child: _pickedImage == null
//               //           ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
//               //           : null,
//               //     ),
//               //   ),
//               // ),
//               const SizedBox(height: 30),

//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   prefixIcon: Icon(Icons.person),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               TextField(
//                 controller: mobileController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: 'Mobile Number',
//                   prefixIcon: Icon(Icons.phone),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               TextField(
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: Icon(Icons.lock),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               DropdownButtonFormField<String>(
//                 value: selectedRole,
//                 onChanged: (value) {
//                   if (value != null) setState(() => selectedRole = value);
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Role',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['user', 'admin', 'staff']
//                     .map((role) => DropdownMenuItem(
//                           value: role,
//                           child: Text(role.capitalize!),
//                         ))
//                     .toList(),
//               ),
//               const SizedBox(height: 30),

//               ElevatedButton(
//                 onPressed: _signUp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0184D2),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Sign Up',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: screenHeight * 0.2,
//               ),
//               Center(
//                 child: Text.rich(
//                   TextSpan(
//                     text: 'Already have an account?',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.textSecondary,
//                     ),
//                     children: [
//                       const TextSpan(text: ' '),
//                       TextSpan(
//                         text: 'Login',
//                         style: const TextStyle(
//                           color: AppColors.black,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             if (!Get.isRegistered<AuthController>()) {
//                               Get.put(AuthController());
//                             }

//                             Get.toNamed('/login');
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: screenHeight * 0.1,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
