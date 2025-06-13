import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_nova/controllers/user_profile/user_setting_controller.dart';

class UserSettingsScreen extends StatelessWidget {
  UserSettingsScreen({super.key});

  final controller = Get.put(SettingsController());

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text("Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: "Change Password",
            onTap: controller.onChangePassword,
          ),
          _buildSettingTile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: controller.onNotifications,
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip,
            title: "Privacy Settings",
            onTap: controller.onPrivacySettings,
          ),
          _buildSettingTile(
            icon: Icons.logout,
            title: "Sign Out",
            onTap: controller.onSignOut,
          ),
        ],
      ),
    );
  }
}
