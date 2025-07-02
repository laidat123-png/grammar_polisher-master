import 'package:flutter/material.dart';
import 'loginEnglish.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';

class RegisterEnglish extends StatefulWidget {
  const RegisterEnglish({Key? key}) : super(key: key);

  @override
  State<RegisterEnglish> createState() => _RegisterEnglishState();
}

class _RegisterEnglishState extends State<RegisterEnglish>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  DateTime? _selectedDate;

  // FocusNodes cho chuyển focus
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  // Thêm biến để lưu trạng thái đã focus (touched) cho từng trường
  final Map<String, bool> _touched = {
    'email': false,
    'name': false,
    'phone': false,
    'dob': false,
    'password': false,
    'confirmPassword': false,
  };
  bool _submitted = false;
  bool _isLoading = false;

  late AnimationController _avatarAnimController;
  late Animation<double> _avatarAnim;

  @override
  void initState() {
    super.initState();
    _avatarAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _avatarAnim = CurvedAnimation(
        parent: _avatarAnimController, curve: Curves.easeOutBack);
    _avatarAnimController.forward();
    // Lắng nghe focus để cập nhật trạng thái touched
    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        setState(() => _touched['email'] = true);
      }
    });
    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) {
        setState(() => _touched['name'] = true);
      }
    });
    _phoneFocus.addListener(() {
      if (_phoneFocus.hasFocus) {
        setState(() => _touched['phone'] = true);
      }
    });
    _dobFocus.addListener(() {
      if (_dobFocus.hasFocus) {
        setState(() => _touched['dob'] = true);
      }
    });
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        setState(() => _touched['password'] = true);
      }
    });
    _confirmPasswordFocus.addListener(() {
      if (_confirmPasswordFocus.hasFocus) {
        setState(() => _touched['confirmPassword'] = true);
      }
    });
  }

  @override
  void dispose() {
    _avatarAnimController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp!')),
      );
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Lưu thông tin bổ sung lên Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'date_of_birth': _dateOfBirthController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginEnglish()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Đăng ký thất bại';
      if (e.code == 'email-already-in-use') {
        message = 'Email đã được sử dụng';
      } else if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ';
      } else if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^0[0-9]{9}$').hasMatch(phone);
  }

  bool _isValidPassword(String pass) {
    return pass.length >= 8;
  }

  bool _isValidConfirmPassword(String pass) {
    return pass == _passwordController.text && pass.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Avatar động
                ScaleTransition(
                  scale: _avatarAnim,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          const AssetImage('assets/images/convet.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title
                const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF87CEEB), // Light blue color
                  ),
                ),
                const SizedBox(height: 10),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Nhập email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: _isValidEmail(_emailController.text)
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                  validator: (val) {
                    if (!(_touched['email']! || _submitted)) return null;
                    if (val == null || val.isEmpty)
                      return 'Vui lòng nhập email';
                    if (!_isValidEmail(val)) return 'Email không hợp lệ';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_nameFocus),
                ),
                const SizedBox(height: 10),

                // Ho ten Input
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: 'Nhập họ tên',
                    labelText: 'Họ tên',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (val) {
                    if (!(_touched['name']! || _submitted)) return null;
                    if (val == null || val.isEmpty)
                      return 'Vui lòng nhập họ tên';
                    if (val.trim().length < 2) return 'Họ tên quá ngắn';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_phoneFocus),
                ),
                const SizedBox(height: 10),

                // Phone Input
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'Nhập số điện thoại',
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: _isValidPhone(_phoneController.text)
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                  validator: (val) {
                    if (!(_touched['phone']! || _submitted)) return null;
                    if (val == null || val.isEmpty)
                      return 'Vui lòng nhập số điện thoại';
                    if (!_isValidPhone(val))
                      return 'Số điện thoại phải bắt đầu bằng 0 và có đúng 10 số';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_dobFocus),
                ),
                const SizedBox(height: 10),

                // Date of Birth Input
                TextFormField(
                  controller: _dateOfBirthController,
                  focusNode: _dobFocus,
                  readOnly: true, // Make it read-only to prevent manual input
                  onTap: () => _selectDate(context), // Show date picker on tap
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    hintText: 'Nhập ngày tháng năm sinh',
                    labelText: 'Ngày tháng năm sinh',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (val) {
                    if (!(_touched['dob']! || _submitted)) return null;
                    if (val == null || val.isEmpty)
                      return 'Vui lòng nhập ngày sinh';
                    if (!val.contains('/')) return 'Ngày sinh không hợp lệ';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                const SizedBox(height: 10),

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: !_isPasswordVisible,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isValidPassword(_passwordController.text))
                          const Icon(Icons.check_circle, color: Colors.green),
                        IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ],
                    ),
                    hintText: 'Nhập mật khẩu',
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (val) {
                    if (!(_touched['password']! || _submitted)) return null;
                    if (val == null || val.isEmpty)
                      return 'Vui lòng nhập mật khẩu';
                    if (!_isValidPassword(val))
                      return 'Mật khẩu phải từ 8 ký tự';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_confirmPasswordFocus),
                ),
                const SizedBox(height: 10),

                // Confirm Password Input
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  obscureText: !_isConfirmPasswordVisible,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isValidConfirmPassword(
                            _confirmPasswordController.text))
                          const Icon(Icons.check_circle, color: Colors.green),
                        IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() =>
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible),
                        ),
                      ],
                    ),
                    hintText: 'Xác nhận mật khẩu',
                    labelText: 'Xác nhận mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (val) {
                    if (!(_touched['confirmPassword']! || _submitted))
                      return null;
                    if (val == null || val.isEmpty)
                      return 'Vui lòng xác nhận mật khẩu';
                    if (!_isValidConfirmPassword(val))
                      return 'Mật khẩu xác nhận không khớp';
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                ),
                const SizedBox(height: 10),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: (_isLoading ||
                              (_formKey.currentState != null &&
                                  !_formKey.currentState!.validate()))
                          ? null
                          : () async {
                              setState(() => _submitted = true);
                              if (_formKey.currentState == null ||
                                  !_formKey.currentState!.validate()) return;
                              setState(() => _isLoading = true);
                              await _register();
                              setState(() => _isLoading = false);
                            },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'HOẶC',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),

                // Social Media Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Image.asset(
                          'assets/images/facebook_logo.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Already have an account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Đã có tài khoản? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginEnglish(),
                          ),
                        );
                      },
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
