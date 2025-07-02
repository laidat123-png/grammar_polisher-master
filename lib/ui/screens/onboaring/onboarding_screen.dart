import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../screen/loginEnglish.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../commons/rounded_button.dart';
import '../../commons/selection_area_with_search.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                OnboardingPage(
                  header: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      'assets/images/convet.png',
                      width: 200,
                    ),
                  ),
                  label: 'Chào mừng đến với Parrot Speak English!',
                  content:
                      'Phương pháp học tiếng Anh tốt nhất trên thế giới!\nChúng tôi rất vui khi có bạn ở đây.\nHãy bắt đầu!',
                ),
                OnboardingPage(
                  header: VocabularyItem(
                    word: Words.sampleWord,
                    onMastered: () {},
                    viewOnly: true,
                  ),
                  label: 'Xem định nghĩa và bắt đầu học!',
                  content:
                      'Bạn có thể nhấn vào bất kỳ từ nào để xem định nghĩa và bắt đầu học nó.',
                ),
                OnboardingPage(
                  header: SelectionAreaWithSearch(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Markdown(
                        data: r'''### 📝 **Adjectives**
      
An **adjective** is a word that describes or modifies a noun or pronoun by providing more information about its quality, size, color, shape, condition, or other attributes.''',
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                  label: 'Bài học ngữ pháp',
                  content:
                      'Bài học ngữ pháp có sẵn cho bạn học. Nhấn và giữ để dịch. Hãy thử nó ngay bây giờ!',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          SmoothPageIndicator(
            controller: _pageController!,
            effect: WormEffect(
              dotColor: colorScheme.secondary.withValues(alpha: 0.3),
              activeDotColor: colorScheme.primary,
              dotHeight: 10,
              dotWidth: 10,
            ),
            count: 3,
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundedButton(
                borderRadius: 16,
                onPressed: _onNext,
                child: const Text('Tiếp tục'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onNext() {
    if (_pageController?.page?.toInt() == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginEnglish(),
        ),
      );
      return;
    }
    _pageController?.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}
