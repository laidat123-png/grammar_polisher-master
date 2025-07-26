import 'package:flutter/material.dart';
import '../../../ui/commons/base_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animController;
  bool _showSuccess = false;
  bool _shakeConfirm = false;
  String? _userName;
  bool _showSuccessText = false;
  bool _isGoogleUser = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _animController.forward();
    _fetchUserName();
    _confirmPasswordController.addListener(_validateConfirm);
    _newPasswordController.addListener(() {
      _validateConfirm();
      setState(() {});
    });
  }

  void _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Check if user signed in with Google
    final isGoogleSignIn = user.providerData
        .any((provider) => provider.providerId == 'google.com');

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data();
    setState(() {
      _isGoogleUser = isGoogleSignIn;
      _userName = data != null &&
              data['name'] != null &&
              data['name'].toString().trim().isNotEmpty
          ? data['name']
          : (user.displayName ?? null);
    });
  }

  double get _passwordStrength {
    final text = _newPasswordController.text;
    if (text.isEmpty) return 0.0;
    int score = 0;
    if (RegExp(r'[A-Z]').hasMatch(text)) score++;
    if (RegExp(r'[a-z]').hasMatch(text)) score++;
    if (RegExp(r'[0-9]').hasMatch(text)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(text)) score++;
    return text.length < 8 ? 0.1 : (score + 1) / 5;
  }

  String get _passwordStrengthLabel {
    final text = _newPasswordController.text;
    if (text.isEmpty) return '';
    if (text.length < 8) return 'Yếu';
    final strength = _passwordStrength;
    if (strength < 0.7) return 'TB';
    return 'Mạnh';
  }

  Color get _passwordStrengthColor {
    final text = _newPasswordController.text;
    if (text.isEmpty || text.length < 8) return Colors.red;
    final strength = _passwordStrength;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }

  bool get _confirmValid =>
      _confirmPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text == _newPasswordController.text;

  void _validateConfirm() {
    if (_confirmPasswordController.text.isEmpty) return;
    if (_confirmPasswordController.text != _newPasswordController.text) {
      setState(() => _shakeConfirm = true);
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _shakeConfirm = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BasePage(
      title: _isGoogleUser ? 'Tạo mật khẩu' : 'Thay đổi mật khẩu',
      child: FadeTransition(
        opacity: _animController,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
                  .animate(_animController),
          child: Stack(
            children: [
              if (_showSuccess)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Lottie.asset('assets/lottie/confetti.json',
                          repeat: false),
                    ),
                  ),
                ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Password security tip
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _isGoogleUser
                                  ? (_userName != null
                                      ? '$_userName ơi, hãy tạo mật khẩu cho tài khoản để tăng cường bảo mật nhé!'
                                      : 'Tạo mật khẩu cho tài khoản Google của bạn với ít nhất 8 ký tự')
                                  : (_userName != null
                                      ? '$_userName ơi, hãy tạo mật khẩu mạnh với ít nhất 8 ký tự để bảo vệ tài khoản nhé!'
                                      : 'Để bảo mật tài khoản, vui lòng tạo mật khẩu mạnh với ít nhất 8 ký tự'),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Current password - only show for non-Google users
                    if (!_isGoogleUser) ...[
                      const Text('Mật khẩu hiện tại',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _currentPasswordController,
                        obscureText: _obscureCurrentPassword,
                        decoration: InputDecoration(
                          hintText: 'Nhập mật khẩu hiện tại',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() =>
                                _obscureCurrentPassword =
                                    !_obscureCurrentPassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // New password
                    const Text('Mật khẩu mới',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      decoration: InputDecoration(
                        hintText: 'Nhập mật khẩu mới',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscureNewPassword = !_obscureNewPassword),
                        ),
                      ),
                    ),
                    // Password strength bar
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: _passwordStrength,
                              minHeight: 7,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _passwordStrengthColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _passwordStrengthLabel,
                            style: TextStyle(
                              color: _passwordStrengthColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Confirm password
                    const Text('Xác nhận mật khẩu mới',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        final shake = _shakeConfirm
                            ? (0.02 * (_animController.value < 0.5 ? 1 : -1))
                            : 0.0;
                        return Transform.translate(
                          offset: Offset(_shakeConfirm ? 8 * shake : 0, 0),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              hintText: 'Nhập lại mật khẩu mới',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_confirmValid)
                                    AnimatedScale(
                                      scale: 1.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: const Icon(Icons.check_circle,
                                          color: Colors.green, size: 22),
                                    ),
                                  IconButton(
                                    icon: Icon(_obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () => setState(() =>
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword),
                                  ),
                                ],
                              ),
                              enabledBorder: _shakeConfirm
                                  ? OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                      borderRadius: BorderRadius.circular(8))
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Update button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        child: const Text('Cập nhật mật khẩu'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Security tips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: Colors.amber),
                              SizedBox(width: 8),
                              Text(
                                'Mẹo bảo mật',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildTip(
                              'Không sử dụng mật khẩu đã sử dụng trước đó'),
                          _buildTip('Thay đổi mật khẩu định kỳ'),
                          _buildTip('Không chia sẻ mật khẩu với bất kỳ ai'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.blue)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _changePassword() async {
    // Validate inputs - skip current password validation for Google users
    if ((!_isGoogleUser && _currentPasswordController.text.isEmpty) ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (_newPasswordController.text.length < 8) {
      _showErrorSnackBar('Mật khẩu mới phải có ít nhất 8 ký tự');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _shakeConfirm = true);
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _shakeConfirm = false);
      });
      _showErrorSnackBar('Mật khẩu mới không khớp');
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorSnackBar('Bạn chưa đăng nhập');
      return;
    }
    try {
      // Ẩn bàn phím
      FocusScope.of(context).unfocus();

      if (!_isGoogleUser) {
        // For email/password users - re-authenticate with current password
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(cred);
      }
      // For Google users, they can directly set a new password without re-authentication

      // Change password
      await user.updatePassword(_newPasswordController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(_isGoogleUser
                    ? 'Tạo mật khẩu thành công'
                    : 'Đổi mật khẩu thành công'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      String message =
          _isGoogleUser ? 'Tạo mật khẩu thất bại' : 'Đổi mật khẩu thất bại';
      if (e.code == 'wrong-password') {
        message = 'Mật khẩu hiện tại không đúng';
      } else if (e.code == 'weak-password') {
        message = 'Mật khẩu mới quá yếu';
      }
      _showErrorSnackBar(message);
    } catch (e) {
      _showErrorSnackBar('Có lỗi xảy ra, vui lòng thử lại');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
