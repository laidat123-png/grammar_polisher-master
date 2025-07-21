import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'bloc/settings_bloc.dart';
import 'widgets/profile_field.dart';
import 'widgets/theme_item.dart';
import 'account_details_screen.dart';
import '../home_navigation/home_navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const seeks = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.red,
  ];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSelectingTheme = false;
  bool _interacted = false;
  late final ScrollController _scrollController;
  static const int _timerPeriod = 8000;
  static const int _duration = 7000;

  static const List<String> kAvatarOptions = [
    'assets/images/Audi.png',
    'assets/images/Bentley.png',
    'assets/images/BMW.png',
  ];

  String? userName;
  String? avatarAsset;
  int streakCount = 5;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchUserName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: _duration),
        curve: Curves.easeInOut,
      );
      Timer.periodic(const Duration(milliseconds: _timerPeriod), (timer) {
        if (_interacted) {
          timer.cancel();
        } else {
          if (_scrollController.position.pixels > 0) {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: _duration),
                curve: Curves.easeInOut);
          } else {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: _duration),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        userName = 'Người dùng';
        avatarAsset = kAvatarOptions[0];
        _loadingUser = false;
      });
      return;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data();
    setState(() {
      userName = data != null &&
              data['name'] != null &&
              data['name'].toString().trim().isNotEmpty
          ? data['name']
          : (user.displayName ?? 'Người dùng');
      avatarAsset = (data != null &&
              data['avatar'] != null &&
              kAvatarOptions.contains(data['avatar']))
          ? data['avatar']
          : kAvatarOptions[0];
      _loadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isGrantedNotificationsPermission =
        context.watch<NotificationsBloc>().state.isNotificationsGranted;
    final isDarkMode = brightness == Brightness.dark;

    return BasePage(
      title: "Cài Đặt",
      padding: EdgeInsets.zero,
      child: Container(
        color: isDarkMode ? const Color(0xFF181A20) : Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar, tên user, lời chào cá nhân
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.grey[400],
                        backgroundImage: avatarAsset != null
                            ? AssetImage(avatarAsset!)
                            : null,
                        child: avatarAsset == null
                            ? Icon(Icons.person, size: 44, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _loadingUser
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Center(
                              child: Text(
                                userName != null && userName!.isNotEmpty
                                    ? '$userName'
                                    : 'Xin chào!',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ],
                  ),
                ),
                // Thông tin tài khoản
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountDetailsScreen(),
                        ),
                      );
                      // Sau khi quay lại, reload tên user
                      _fetchUserName();
                    },
                    child: ListTile(
                      leading: Icon(Icons.person_outline,
                          color: colorScheme.primary, size: 32),
                      title: Text(
                        "Thông tin tài khoản",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("Quản lý thông tin cá nhân"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Mẫu từ vựng - hiệu ứng động
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 30),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: VocabularyItem(
                      word: Words.sampleWord,
                      viewOnly: true,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Màu sắc - hiệu ứng scale khi chọn
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.palette, color: colorScheme.primary),
                            SizedBox(width: 8),
                            Text(
                              "Màu sắc",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                List.generate(SettingsScreen.seeks.length, (i) {
                              final color = SettingsScreen.seeks[i];
                              final isSelected = context
                                      .read<SettingsBloc>()
                                      .state
                                      .settingsSnapshot
                                      .seek ==
                                  i;
                              return GestureDetector(
                                onTap: () => _onChangeColor(context, i),
                                child: AnimatedScale(
                                  scale: isSelected ? 1.2 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: color.withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                      ],
                                      border: isSelected
                                          ? Border.all(
                                              color: Colors.blueAccent,
                                              width: 2)
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Chế độ - hiệu ứng động icon
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, anim) =>
                              RotationTransition(turns: anim, child: child),
                          child: context
                                      .read<SettingsBloc>()
                                      .state
                                      .settingsSnapshot
                                      .themeMode ==
                                  ThemeMode.system.index
                              ? Icon(Icons.wb_sunny,
                                  color: colorScheme.primary,
                                  key: ValueKey('sun'))
                              : Icon(Icons.nightlight_round,
                                  color: colorScheme.primary,
                                  key: ValueKey('moon')),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chế độ",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              context
                                          .read<SettingsBloc>()
                                          .state
                                          .settingsSnapshot
                                          .themeMode ==
                                      ThemeMode.system.index
                                  ? 'Tự động'
                                  : context
                                              .read<SettingsBloc>()
                                              .state
                                              .settingsSnapshot
                                              .themeMode ==
                                          ThemeMode.dark.index
                                      ? 'Tối'
                                      : 'Sáng',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Spacer(),
                        Switch(
                          value: context
                                  .read<SettingsBloc>()
                                  .state
                                  .settingsSnapshot
                                  .themeMode ==
                              ThemeMode.light.index,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            _onChangeTheme(
                                context,
                                value
                                    ? ThemeMode.light.index
                                    : ThemeMode.dark.index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Liên hệ
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _openContactPhone,
                    child: ListTile(
                      leading: Icon(Icons.phone, color: colorScheme.primary),
                      title: Text(
                        "Liên hệ",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("Hỗ trợ khách hàng 24/7"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Điều khoản chính sách
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.push('/terms_of_use');
                    },
                    child: ListTile(
                      leading:
                          Icon(Icons.privacy_tip, color: colorScheme.primary),
                      title: Text(
                        "Điều khoản chính sách",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle:
                          Text("Xem chi tiết điều khoản & chính sách bảo mật"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Hủy tài khoản
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Xác nhận hủy tài khoản'),
                          content: Text(
                              'Bạn có chắc chắn muốn hủy tài khoản? Hành động này không thể hoàn tác.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Không'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Đồng ý'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          final uid = user?.uid;
                          await user?.delete();
                          if (uid != null) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .delete();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Đã xóa tài khoản nhưng không xóa được dữ liệu Firestore: $e')),
                              );
                            }
                          }
                          if (context.mounted) {
                            context.go('/login');
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'requires-recent-login') {
                            // Hiện dialog nhập lại mật khẩu
                            final password = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final controller = TextEditingController();
                                return AlertDialog(
                                  title: Text('Xác thực lại'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          'Vui lòng nhập lại mật khẩu để xác thực trước khi hủy tài khoản.'),
                                      SizedBox(height: 16),
                                      TextField(
                                        controller: controller,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Mật khẩu',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context)
                                          .pop(controller.text),
                                      child: Text('Xác nhận'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (password != null && password.isNotEmpty) {
                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                final email = user?.email;
                                final uid = user?.uid;
                                if (user != null && email != null) {
                                  final cred = EmailAuthProvider.credential(
                                      email: email, password: password);
                                  await user.reauthenticateWithCredential(cred);
                                  await user.delete();
                                  if (uid != null) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uid)
                                          .delete();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Đã xóa tài khoản nhưng không xóa được dữ liệu Firestore: $e')),
                                      );
                                    }
                                  }
                                  if (context.mounted) {
                                    context.go('/login');
                                  }
                                }
                              } on FirebaseAuthException catch (e2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Xác thực thất bại: ${e2.message ?? e2.code}')),
                                );
                              } catch (e2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Có lỗi xảy ra khi xác thực: $e2')),
                                );
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Không thể hủy tài khoản: ${e.message ?? e.code}')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Không thể hủy tài khoản: $e')),
                          );
                        }
                      }
                    },
                    child: ListTile(
                      leading: Icon(Icons.delete_forever, color: Colors.red),
                      title: Text(
                        "Hủy tài khoản",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Đăng xuất
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        "Đăng xuất",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onChangeTheme(BuildContext context, int themeMode) {
    context
        .read<SettingsBloc>()
        .add(SettingsEvent.saveSettings(themeMode: themeMode));
    setState(() {
      _isSelectingTheme = false;
    });
    // Điều hướng lại đúng tab đang chọn sau khi đổi theme
    Future.delayed(const Duration(milliseconds: 100), () {
      context.go(HomeNavigation.routes[globalTabIndex]);
    });
  }

  void _onChangeColor(BuildContext context, int colorIndex) {
    context
        .read<SettingsBloc>()
        .add(SettingsEvent.saveSettings(seek: colorIndex));
    // Điều hướng lại đúng tab đang chọn sau khi đổi màu sắc
    Future.delayed(const Duration(milliseconds: 100), () {
      context.go(HomeNavigation.routes[globalTabIndex]);
    });
  }

  Future<void> _openContactPhone() async {
    final url = Uri.parse('tel:0703369307');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở ứng dụng gọi điện.')),
      );
    }
  }

  void _openNotificationsSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void _showThemeModeDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chọn chế độ hiển thị"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    Icon(Icons.light_mode_outlined, color: colorScheme.primary),
                title: Text("Sáng"),
                onTap: () {
                  Navigator.pop(context);
                  _onChangeTheme(context, ThemeMode.light.index);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.dark_mode_outlined, color: colorScheme.primary),
                title: Text("Tối"),
                onTap: () {
                  Navigator.pop(context);
                  _onChangeTheme(context, ThemeMode.dark.index);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy"),
            ),
          ],
        );
      },
    );
  }
}
