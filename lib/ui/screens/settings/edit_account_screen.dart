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
  final _formKey = GlobalKey<FormState>();

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
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

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

  String? _validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng chọn ngày sinh';
    }

    // Validate date format (dd/mm/yyyy)
    final dateRegex = RegExp(r'^(\d{1,2})\/(\d{1,2})\/(\d{4})$');
    if (!dateRegex.hasMatch(value)) {
      return 'Định dạng ngày không hợp lệ (dd/mm/yyyy)';
    }

    try {
      final parts = value.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      // Basic validation for day, month, year
      if (month < 1 || month > 12) {
        return 'Tháng không hợp lệ (1-12)';
      }

      if (day < 1 || day > 31) {
        return 'Ngày không hợp lệ (1-31)';
      }

      // Create date to validate
      final date = DateTime(year, month, day);
      final now = DateTime.now();

      // Check if date is in the future
      if (date.isAfter(now)) {
        return 'Ngày sinh không thể ở tương lai';
      }

      // Check if person is too old (over 120 years)
      final age = now.year - year;
      if (age > 120) {
        return 'Tuổi không hợp lệ';
      }

      // Check if person is too young (under 1 year)
      if (age < 1) {
        return 'Phải từ 1 tuổi trở lên';
      }
    } catch (e) {
      return 'Ngày sinh không hợp lệ';
    }

    return null;
  }

  Future<void> _selectDate() async {
    // Parse current date if exists
    DateTime initialDate = DateTime.now();
    if (_dobController.text.isNotEmpty) {
      try {
        final parts = _dobController.text.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);

          // Validate parsed date
          final parsedDate = DateTime(year, month, day);
          final now = DateTime.now();

          // Use parsed date only if it's valid and not in future
          if (parsedDate.isBefore(now) || parsedDate.isAtSameMomentAs(now)) {
            initialDate = parsedDate;
          }
        }
      } catch (e) {
        // Use current date if parsing fails
        initialDate = DateTime.now();
      }
    }

    // Ensure initialDate is not in the future
    final now = DateTime.now();
    if (initialDate.isAfter(now)) {
      initialDate = now;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formattedDate = '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
      setState(() {
        _dobController.text = formattedDate;
      });
    }
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
                  backgroundColor: Colors.grey[400],
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
        child: Form(
          key: _formKey,
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
                    backgroundColor: Colors.grey[400],
                    backgroundImage: _selectedAvatar != null
                        ? AssetImage(_selectedAvatar!)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Họ tên', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  if (value.trim().length < 2) {
                    return 'Họ tên phải có ít nhất 2 ký tự';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập họ tên',
                ),
              ),
              const SizedBox(height: 20),
              Text('Số điện thoại', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (!RegExp(r'^0[0-9]{9}$').hasMatch(value.trim())) {
                    return 'Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập số điện thoại',
                ),
              ),
              const SizedBox(height: 20),
              Text('Ngày sinh', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: _selectDate,
                validator: _validateDateOfBirth,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Chọn ngày sinh (vd: 15/6/2005)',
                  suffixIcon: Icon(Icons.calendar_today),
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
      ),
    );
  }
}
