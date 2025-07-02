import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginEnglish.dart';

class QuenmatkhauEnglish extends StatefulWidget {
  const QuenmatkhauEnglish({Key? key}) : super(key: key);

  @override
  State<QuenmatkhauEnglish> createState() => _QuenmatkhauEnglishState();
}

class _QuenmatkhauEnglishState extends State<QuenmatkhauEnglish> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _showSuccessIcon = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorMessage('Vui lòng nhập địa chỉ email');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorMessage('Địa chỉ email không hợp lệ');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        setState(() {
          _showSuccessIcon = true;
        });
        _showSuccessMessage(
            'Yêu cầu đặt lại mật khẩu đã được gửi đến email của bạn');
        // Chờ một chút để người dùng đọc thông báo thành công
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showSuccessIcon = false;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginEnglish()),
            );
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Đã xảy ra lỗi khi đặt lại mật khẩu';
      if (e.code == 'user-not-found') {
        message = 'Không tìm thấy tài khoản với email này';
      } else if (e.code == 'invalid-email') {
        message = 'Địa chỉ email không hợp lệ';
      }
      _showErrorMessage(message);
    } catch (e) {
      _showErrorMessage('Đã xảy ra lỗi không xác định');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEEB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.security, color: Colors.white, size: 26),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon minh họa lớn với hiệu ứng xuất hiện
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _showSuccessIcon
                    ? Icon(Icons.check_circle_rounded,
                        key: const ValueKey('success'),
                        color: Colors.green,
                        size: 90)
                    : Icon(Icons.lock_reset,
                        key: const ValueKey('reset'),
                        color: Colors.blue.shade300,
                        size: 90),
              ),
              const SizedBox(height: 18),
              // Title
              const Text(
                'Quên mật khẩu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF87CEEB),
                ),
              ),
              const SizedBox(height: 10),
              // Thông điệp động viên
              const Text(
                'Đừng lo, chúng tôi sẽ giúp bạn lấy lại tài khoản! 💪',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),
              const Text(
                'Vui lòng nhập địa chỉ email của bạn để đặt lại mật khẩu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 36),
              // Email Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Nhập email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Reset Password Button
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _isLoading ? 0.7 : 1.0,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.13),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Đặt lại mật khẩu',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
