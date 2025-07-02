import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> kAvatarOptions = [
  'assets/images/Audi.png',
  'assets/images/Bentley.png',
  'assets/images/BMW.png',
];

class EditAccountScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String dob;
  const EditAccountScreen(
      {super.key, required this.name, required this.phone, required this.dob});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  bool _loading = false;
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _dobController = TextEditingController(text: widget.dob);
    _loadAvatar();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _loadAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data();
    setState(() {
      _selectedAvatar = (data != null &&
              data['avatar'] != null &&
              kAvatarOptions.contains(data['avatar']))
          ? data['avatar']
          : kAvatarOptions[0];
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();
    if (name.isEmpty || phone.isEmpty || dob.isEmpty) {
      _showSnackBar('Vui lòng điền đầy đủ thông tin', isError: true);
      return;
    }
    if (!RegExp(r'^0[0-9]{9}$').hasMatch(phone)) {
      _showSnackBar('Hãy nhập SĐT hợp lệ', isError: true);
      return;
    }
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Bạn chưa đăng nhập', isError: true);
      setState(() => _loading = false);
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name,
        'phone': phone,
        'date_of_birth': dob,
        'avatar': _selectedAvatar,
      });
      if (mounted) {
        _showSnackBar('Cập nhật thành công!', isError: false);
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context)
            .pop({'name': name, 'phone': phone, 'date_of_birth': dob});
      }
    } catch (e) {
      _showSnackBar('Có lỗi xảy ra: $e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error : Icons.check_circle,
                color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAvatarPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn avatar'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: kAvatarOptions.map((path) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(path),
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(path),
                  backgroundColor: Colors.grey[200],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _selectedAvatar = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Avatar chọn ảnh
            Center(
              child: GestureDetector(
                onTap: _showAvatarPicker,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: _selectedAvatar != null
                      ? AssetImage(_selectedAvatar!)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Họ tên', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập họ tên',
              ),
            ),
            const SizedBox(height: 20),
            Text('Số điện thoại', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập số điện thoại',
              ),
            ),
            const SizedBox(height: 20),
            Text('Ngày sinh', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập ngày sinh (vd: 15/6/2005)',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
