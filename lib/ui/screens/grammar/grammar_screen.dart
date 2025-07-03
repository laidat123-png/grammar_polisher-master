import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../generated/assets.dart';
import '../../../data/models/category_data.dart';
import '../../../data/models/lesson.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import 'bloc/lesson_bloc.dart';
import 'widget/home_item.dart';
import '../vocabulary/widgets/search_box.dart';
import '../../../constants/word_pos.dart';
import 'package:grammar_polisher/data/models/word.dart';
import 'package:grammar_polisher/ui/screens/review/widgets/schedule_modal.dart';
import 'package:grammar_polisher/ui/screens/vocabulary/bloc/vocabulary_bloc.dart';

class GrammarScreen extends StatefulWidget {
  final List<CategoryData> categories = [
    const CategoryData(
        id: 1,
        title: 'Các thì',
        description: '13 thì trong tiếng anh',
        progress: 0,
        total: 13,
        lessons: [
          Lesson(
              id: 1,
              title: 'Hiên tại đơn',
              subTitle: 'S + to be/V + O',
              path: Assets.presentSimplePresentTense),
          Lesson(
              id: 2,
              title: 'Hiện tại tiếp diễn',
              subTitle: 'S + to be + V-ing + O',
              path: Assets.presentPresentContinuousTense),
          Lesson(
              id: 3,
              title: 'Hiện tại hoàn thành',
              subTitle: 'S + have/has + V3 + O',
              path: Assets.presentPresentPerfectTense),
          Lesson(
              id: 4,
              title: 'Hiện tại hoàn thành tiếp diễn',
              subTitle: 'S + have/has + been + V-ing + O',
              path: Assets.presentPresentPerfectContinuousTense),
          Lesson(
              id: 5,
              title: 'Quá khứ đơn',
              subTitle: 'S + V2 + O',
              path: Assets.pastSimplePastTense),
          Lesson(
              id: 6,
              title: 'Quá khứ tiếp diễn',
              subTitle: 'S + was/were + V-ing + O',
              path: Assets.pastPastContinuousTense),
          Lesson(
              id: 7,
              title: 'Qua khứ hoàn thành',
              subTitle: 'S + had + V3 + O',
              path: Assets.pastPastPerfectTense),
          Lesson(
              id: 8,
              title: 'Quá khứ hoàn thành tiếp diễn',
              subTitle: 'S + had + been + V-ing + O',
              path: Assets.pastPastPerfectContinuousTense),
          Lesson(
              id: 9,
              title: 'Tương lai đơn',
              subTitle: 'S + will + V + O',
              path: Assets.futureFutureSimpleTense),
          Lesson(
              id: 10,
              title: 'Tương lai tiếp diễn',
              subTitle: 'S + will + be + V-ing + O',
              path: Assets.futureFutureContinuousTense),
          Lesson(
              id: 11,
              title: 'Tương lai hoàn thành',
              subTitle: 'S + will + have + V3 + O',
              path: Assets.futureFuturePerfectTense),
          Lesson(
              id: 12,
              title: 'Tương lai hoàn thành tiếp diễn',
              subTitle: 'S + will + have + been + V-ing + O',
              path: Assets.futureFuturePerfectContinuousTense),
          Lesson(
              id: 13,
              title: 'Tương lai gần',
              subTitle: 'S + to be + going to + V + O',
              path: Assets.futureNearFuture),
        ]),
    const CategoryData(
        id: 2,
        title: 'Các câu',
        description: 'Các loại câu trong tiếng anh',
        progress: 0,
        total: 8,
        lessons: [
          Lesson(
              id: 14,
              title: 'Câu bị động',
              subTitle: 'Nhấn mạnh hành động thay vì người thực hiện',
              path: Assets.sentencesPassiveVoice),
          Lesson(
              id: 15,
              title: 'Câu gián tiếp',
              subTitle: 'Tường thuật lại lời của người khác',
              path: Assets.sentencesReportedSpeech),
          Lesson(
              id: 16,
              title: 'Câu điều kiện',
              subTitle: 'Diễn tả điều kiện và kết quả',
              path: Assets.sentencesConditionalSentences),
          Lesson(
              id: 17,
              title: 'Câu cảm thán',
              subTitle: 'Thể hiện cảm xúc mạnh mẽ',
              path: Assets.sentencesExclamatorySentences),
          Lesson(
              id: 18,
              title: 'Câu so sánh',
              subTitle: 'So sánh giữa hai hoặc nhiều đối tượng',
              path: Assets.sentencesComparisonSentences),
          Lesson(
              id: 19,
              title: 'Câu ước',
              subTitle: 'Diễn tả mong muốn hoặc điều không có thật',
              path: Assets.sentencesWishSentences),
          Lesson(
              id: 20,
              title: 'Câu hỏi đuôi',
              subTitle: 'Câu hỏi ngắn ở cuối câu để xác nhận thông tin',
              path: Assets.sentencesQuestionTags),
          Lesson(
              id: 21,
              title: 'Câu mệnh lệnh',
              subTitle: 'Đưa ra yêu cầu, mệnh lệnh hoặc lời khuyên',
              path: Assets.sentencesImperativeSentences),
        ]),
    const CategoryData(
        id: 3,
        title: 'Các từ loại',
        description: 'Các từ loại trong tiếng anh',
        progress: 0,
        total: 9,
        lessons: [
          Lesson(
              id: 22,
              title: 'Danh từ',
              subTitle: 'Người, địa điểm, vật hoặc ý tưởng',
              path: Assets.wordFamiliesNouns),
          Lesson(
              id: 23,
              title: 'Đại từ',
              subTitle: 'Thay thế danh từ',
              path: Assets.wordsPronouns),
          Lesson(
              id: 24,
              title: 'Tính từ',
              subTitle: 'Miêu tả danh từ',
              path: Assets.wordFamiliesAdjectives),
          Lesson(
              id: 25,
              title: 'Trạng từ',
              subTitle: 'Bổ nghĩa cho động từ, tính từ hoặc trạng từ khác',
              path: Assets.wordFamiliesAdverbs),
          Lesson(
              id: 26,
              title: 'Động từ',
              subTitle: 'Diễn tả hành động, trạng thái hoặc sự việc',
              path: Assets.wordFamiliesVerbs),
          Lesson(
              id: 27,
              title: 'Giới từ',
              subTitle: 'Thể hiện mối quan hệ giữa danh từ và từ khác',
              path: Assets.wordsPreposition),
          Lesson(
              id: 28,
              title: 'Liên từ',
              subTitle: 'Kết nối từ, cụm từ hoặc mệnh đề',
              path: Assets.wordsConjunction),
          Lesson(
              id: 29,
              title: 'Thán từ',
              subTitle: 'Thể hiện cảm xúc mạnh mẽ hoặc cảm xúc',
              path: Assets.wordsInterjection),
          Lesson(
              id: 32,
              title: 'Modals Verbs',
              subTitle: 'Có thể, có lẽ, phải, nên, sẽ, v.v.',
              path: Assets.wordsModalVerbs),
        ]),
    const CategoryData(
        id: 4,
        title: "Khác",
        description: "Các chủ đề ngữ pháp khác",
        progress: 0,
        total: 5,
        lessons: [
          Lesson(
              id: 33,
              title: "Gia đình từ",
              subTitle: "Các từ có liên quan với nhau",
              path: Assets.wordFamiliesWordFamilies),
          Lesson(
              id: 34,
              title: "Cụm động từ",
              subTitle: "Động từ + giới từ hoặc trạng từ",
              path: Assets.grammarPhrasalVerbs),
          Lesson(
              id: 35,
              title: "Thành ngữ",
              subTitle: "Thành ngữ có nghĩa khác với nghĩa từng từ riêng lẻ",
              path: Assets.grammarIdioms),
          Lesson(
              id: 36,
              title: "Tục ngữ",
              subTitle:
                  "Câu nói ngắn gọn đưa ra lời khuyên hoặc thể hiện quan điểm",
              path: Assets.grammarProverbs),
          Lesson(
              id: 37,
              title: "Định lượng",
              subTitle: "Các từ miêu tả số lượng",
              path: Assets.grammarQuantifiers),
        ]),
  ];

  GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  String query = '';
  bool _showSearch = false;
  final List<WordPos> _selectedPos = [];
  String? _selectedLetter;
  String _searchText = '';
  String? userName;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        userName = 'Người dùng';
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
      _loadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final queriedCategories = query.isNotEmpty
        ? widget.categories.where((element) {
            return element.title.toLowerCase().contains(query.toLowerCase()) ||
                element.description.toLowerCase().contains(query.toLowerCase());
          }).toList()
        : widget.categories;
    final vocabularyState =
        context.watch<VocabularyBloc>().state; // Access VocabularyBloc
    final reviewWords = vocabularyState.words;
    final textTheme = Theme.of(context).textTheme; // Access textTheme
    final colorScheme = Theme.of(context).colorScheme; // Access colorScheme

    return BasePage(
      title: 'Ngữ Pháp',
      actions: [
        TextButton(
          onPressed: () => _showScheduleModal(context, reviewWords),
          child: Text(
            'Lịch Trình',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_loadingUser)
              const Padding(
                padding: EdgeInsets.only(top: 12, bottom: 8),
                child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (userName != null)
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Text(
                  'Chào mừng trở lại\n$userName!',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            SearchBox(
              showSearch: _showSearch,
              selectedPos: _selectedPos,
              selectedLetter: _selectedLetter,
              onSearch: (value) {
                setState(() {
                  query = value;
                  _searchText = value; // Update _searchText as well
                });
              },
              onClearFilters: () {
                setState(() {
                  query = '';
                  _selectedPos.clear();
                  _selectedLetter = null;
                  _searchText = '';
                });
              },
              onSelectPos: (pos) {
                setState(() {
                  if (_selectedPos.contains(pos)) {
                    _selectedPos.remove(pos);
                  } else {
                    _selectedPos.add(pos);
                  }
                });
              },
              onSelectLetter: (letter) {
                setState(() {
                  _selectedLetter = letter;
                });
              },
            ),
            const SizedBox(height: 16),
            if (query.isNotEmpty && queriedCategories.isEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'No categories found for "$query"',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
            ],
            if (query.isEmpty || queriedCategories.isNotEmpty)
              BlocBuilder<LessonBloc, LessonState>(
                builder: (context, state) {
                  final markedLessons = state.markedLessons;
                  return Column(
                    children: [
                      ...queriedCategories.map((category) {
                        final total = category.lessons.length;
                        final completed = category.lessons
                            .where((lesson) => markedLessons[lesson.id] == true)
                            .length;
                        final dynamicCategory = category.copyWith(
                          progress: completed,
                          total: total,
                        );
                        return Column(
                          children: [
                            if (category.id == 2) ...[
                              const BannerAdWidget(
                                paddingHorizontal: 0,
                                paddingVertical: 16,
                              ),
                            ],
                            HomeItem(
                              category: dynamicCategory,
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showScheduleModal(BuildContext context, List<Word> reviewWords) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ScheduleModal(
        reviewWords: reviewWords,
      ),
    );
  }
}
