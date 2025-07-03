import 'package:flutter/material.dart';
import '../../../ui/commons/base_page.dart';
import 'change_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/settings_bloc.dart';
import 'edit_account_screen.dart';

const List<String> kAvatarOptions = [
  'assets/images/Audi.png',
  'assets/images/Bentley.png',
  'assets/images/BMW.png',
];

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int streakCount = 5; // Giả lập, có thể truyền từ ngoài vào nếu cần

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data();
  }

  Future<void> _showEditDialog(Map<String, dynamic> userData) async {
    final nameController = TextEditingController(text: userData['name'] ?? '');
    final phoneController =
        TextEditingController(text: userData['phone'] ?? '');
    final dobController =
        TextEditingController(text: userData['date_of_birth'] ?? '');
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa thông tin'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Họ tên'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dobController,
                  decoration: const InputDecoration(
                      labelText: 'Ngày sinh (vd: 15/6/2005)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'date_of_birth': dobController.text,
                });
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        _editedUserData = {
          ...userData,
          ...result,
        };
      });
      // Lưu lên Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'name': result['name'],
            'phone': result['phone'],
            'date_of_birth': result['date_of_birth'],
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật thông tin thành công!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi khi cập nhật: $e')),
            );
          }
        }
      }
    }
  }

  Map<String, dynamic>? _editedUserData;

  Future<void> _reloadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      _editedUserData = doc.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BasePage(
      title: 'Thông tin tài khoản',
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
            return const SizedBox();
          }
          final userData = _editedUserData ?? snapshot.data!;
          return FadeTransition(
            opacity: _animController,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
                      .animate(_animController),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Avatar với badge và hiệu ứng đổi ảnh
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[400],
                                backgroundImage: userData['avatar'] != null &&
                                        kAvatarOptions
                                            .contains(userData['avatar'])
                                    ? AssetImage(userData['avatar'])
                                    : AssetImage(kAvatarOptions[0]),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Nút chỉnh sửa thông tin
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditAccountScreen(
                                    name: userData['name'] ?? '',
                                    phone: userData['phone'] ?? '',
                                    dob: userData['date_of_birth'] ?? '',
                                  ),
                                ),
                              );
                              if (result is Map<String, String>) {
                                await _reloadUserData();
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Chỉnh sửa thông tin'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              side: BorderSide(color: colorScheme.primary),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // User details
                        _buildInfoField(context, 'Email',
                            userData['email'] ?? '', Icons.email),
                        _buildInfoField(context, 'Họ tên',
                            userData['name'] ?? '', Icons.person),
                        _buildInfoField(context, 'Số điện thoại',
                            userData['phone'] ?? '', Icons.phone),
                        _buildInfoField(
                            context,
                            'Ngày sinh',
                            userData['date_of_birth'] ?? '',
                            Icons.calendar_today),
                        const SizedBox(height: 24),
                        // Change password button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Đổi mật khẩu'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Phiên bản 1.0.0 ©2024 MyApp',
                          style:
                              textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoField(
      BuildContext context, String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
