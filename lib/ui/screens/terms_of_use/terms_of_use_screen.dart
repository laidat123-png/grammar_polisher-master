import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều khoản & Chính sách'),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner minh họa
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/convet.png',
                      width: 90,
                      height: 90,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 1. Mục đích sử dụng
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.flag, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          const TextSpan(text: '1. Mục đích sử dụng\n'),
                          TextSpan(
                            text:
                                'Ứng dụng này được phát triển nhằm hỗ trợ người dùng học tiếng Anh, ',
                            style: textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'luyện tập từ vựng, ngữ pháp',
                            style: textTheme.bodyLarge?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 2. Quyền riêng tư
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          const TextSpan(text: '2. Quyền riêng tư\n'),
                          TextSpan(
                            text: 'Chúng tôi cam kết ',
                            style: textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'bảo vệ thông tin cá nhân',
                            style: textTheme.bodyLarge?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                ' của bạn. Dữ liệu cá nhân chỉ được sử dụng để cải thiện trải nghiệm học tập và sẽ không được chia sẻ với bên thứ ba khi chưa có sự đồng ý của bạn.',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 3. Trách nhiệm người dùng
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          const TextSpan(text: '3. Trách nhiệm người dùng\n'),
                          TextSpan(
                            text: 'Người dùng có trách nhiệm ',
                            style: textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'bảo mật tài khoản',
                            style: textTheme.bodyLarge?.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                ', không sử dụng ứng dụng vào mục đích vi phạm pháp luật hoặc gây ảnh hưởng xấu đến cộng đồng.',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 4. Bản quyền nội dung
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.copyright, color: Colors.purple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          const TextSpan(text: '4. Bản quyền nội dung\n'),
                          TextSpan(
                            text:
                                'Mọi nội dung, hình ảnh, tài liệu trong ứng dụng thuộc ',
                            style: textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'bản quyền của nhà phát triển hoặc đối tác',
                            style: textTheme.bodyLarge?.copyWith(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '. Nghiêm cấm sao chép, phát tán khi chưa được phép.',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 5. Liên hệ & hỗ trợ
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.support_agent, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          const TextSpan(text: '5. Liên hệ & hỗ trợ\n'),
                          TextSpan(
                            text:
                                'Nếu bạn có bất kỳ thắc mắc hoặc cần hỗ trợ, vui lòng liên hệ qua email: ',
                            style: textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'laiphucdat2004@gmail.com',
                            style: textTheme.bodyLarge?.copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Cảm ơn bạn đã sử dụng ứng dụng học tiếng Anh của chúng tôi!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'laiphucdat2004@gmail.com',
                          query: Uri.encodeFull(
                              'subject=Hỗ trợ ứng dụng học tiếng Anh&body=Chào đội ngũ hỗ trợ,\n\nTôi cần được giúp đỡ về...'),
                        );
                        if (await canLaunchUrl(emailLaunchUri)) {
                          await launchUrl(emailLaunchUri);
                        }
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Gửi email hỗ trợ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
}
