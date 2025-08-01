import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/word_pos.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/svg_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import 'bloc/vocabulary_bloc.dart';
import 'widgets/search_box.dart';
import 'widgets/vocabulary_item.dart';

enum DisplayMode {
  allWords,
  savedWords,
  searchHistory,
}

class VocabularyScreen extends StatefulWidget {
  final int? wordId;

  const VocabularyScreen({super.key, this.wordId});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  bool _showSearch = true;
  final List<WordPos> _selectedPos = [];
  String? _selectedLetter;
  String _searchText = '';
  DisplayMode _displayMode = DisplayMode.allWords;

  late stt.SpeechToText _speech;
  bool _isListening = false;

  // Lazy loading state
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  List<Word> _visibleWords = [];
  List<Word> _filteredWords = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    context
        .read<VocabularyBloc>()
        .add(const VocabularyEvent.getAllOxfordWords());
    _showWordDetails();
    _listenNotificationsBloc();
    _scrollController.addListener(_onScroll);
    // Khởi tạo dữ liệu ban đầu nếu có
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final words = context.read<VocabularyBloc>().state.words;
      _updateFilteredWords(words);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreWords();
    }
  }

  void _loadMoreWords() {
    if (_visibleWords.length >= _filteredWords.length) return;
    setState(() {
      _isLoadingMore = true;
      int nextMax = _currentMax + 10;
      if (nextMax > _filteredWords.length) nextMax = _filteredWords.length;
      _visibleWords = _filteredWords.sublist(0, nextMax);
      _currentMax = nextMax;
      _isLoadingMore = false;
    });
  }

  void _updateFilteredWords(List<Word> allWords) {
    _filteredWords = List<Word>.from(_getFilteredWords(allWords));
    int initialMax = _filteredWords.length < 10 ? _filteredWords.length : 10;
    _currentMax = initialMax; // Reset về 10 mỗi lần filter/search thay đổi
    _visibleWords = _filteredWords.sublist(0, initialMax);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VocabularyBloc, VocabularyState>(
      listener: (context, state) {
        _showWordDetails();
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: BasePage(
            title: 'Tra từ',
            actions: [],
            padding: const EdgeInsets.all(0),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBox(
                    showSearch: true,
                    selectedPos: _selectedPos,
                    selectedLetter: _selectedLetter,
                    onSelectPos: _onSelectPos,
                    onSelectLetter: _onSelectLetter,
                    onClearFilters: _onClearFilters,
                    onSearch: _onSearch,
                    onMic: _onMic,
                    text: _searchText,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          "Từ vựng yêu thích",
                          Icons.book,
                          false,
                          () => context.push(RoutePaths.savedWords),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          "Lịch sử tra cứu",
                          Icons.history,
                          false,
                          () => context.push(RoutePaths.searchHistory),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _filteredWords.isEmpty
                        ? SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Không tìm thấy từ nào. Thám tử đang giúp bạn tìm kiếm từ vựng!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Image.asset(
                                      'assets/images/detective2.png',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Flexible(
                            fit: FlexFit.loose,
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: _visibleWords.length +
                                  (_visibleWords.length < _filteredWords.length
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index < _visibleWords.length) {
                                  final word = _visibleWords[index];
                                  return Column(
                                    children: [
                                      VocabularyItem(word: word),
                                      if (index == 1) ...[
                                        BannerAdWidget(
                                          paddingHorizontal: 16,
                                          paddingVertical: 8,
                                        ),
                                      ]
                                    ],
                                  );
                                } else {
                                  // Hiện loading indicator khi đang tải thêm
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectPos(WordPos pos) {
    setState(() {
      _displayMode = DisplayMode.allWords;
      _showSearch = true;
      if (_selectedPos.contains(pos)) {
        _selectedPos.remove(pos);
      } else {
        _selectedPos.add(pos);
      }
      final words = context.read<VocabularyBloc>().state.words;
      _updateFilteredWords(words);
    });
    _scrollController.jumpTo(0); // Reset scroll về đầu
  }

  void _onSelectLetter(String? letter) {
    setState(() {
      _displayMode = DisplayMode.allWords;
      _showSearch = true;
      _selectedLetter = letter;
      final words = context.read<VocabularyBloc>().state.words;
      _updateFilteredWords(words);
    });
    _scrollController.jumpTo(0); // Reset scroll về đầu
  }

  void _onClearFilters() {
    setState(() {
      _selectedPos.clear();
      _selectedLetter = null;
      _searchText = '';
      _displayMode = DisplayMode.allWords;
      final words = context.read<VocabularyBloc>().state.words;
      _updateFilteredWords(words);
    });
    _scrollController.jumpTo(0); // Reset scroll về đầu
  }

  void _onSearch(String text) {
    setState(() {
      _searchText = text;
      _displayMode = DisplayMode.allWords;
      final words = context.read<VocabularyBloc>().state.words;
      _updateFilteredWords(words);
    });
    _scrollController.jumpTo(0); // Reset scroll về đầu
  }

  void _onMic() async {
    // Xin quyền micro trước khi khởi tạo speech_to_text
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Yêu cầu quyền micro'),
            content:
                const Text('Bạn cần cấp quyền micro để sử dụng chức năng này.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }
      return;
    }
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _searchText = result.recognizedWords;
              _displayMode = DisplayMode.allWords;
            });
          },
          listenFor: const Duration(seconds: 5),
          pauseFor: const Duration(seconds: 2),
          localeId: 'en_US', // hoặc 'vi_VN' nếu muốn nhận diện tiếng Việt
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  _getFilteredWords(List<Word> words) {
    // Trả về danh sách phù hợp với chế độ hiển thị
    if (_displayMode == DisplayMode.savedWords) {
      return words.where((word) => word.userDefinition == 'favorite').toList();
    } else if (_displayMode == DisplayMode.searchHistory) {
      return <Word>[];
    }

    // Nếu không có bộ lọc nào được áp dụng và không có văn bản tìm kiếm, trả về danh sách trống
    if (_searchText.isEmpty &&
        _selectedPos.isEmpty &&
        _selectedLetter == null) {
      return <Word>[];
    }

    // Lọc từ theo các tiêu chí
    return words.where((word) {
      // Kiểm tra loại từ (part of speech)
      final pos = word.pos.split(', ');
      final containsPos = _selectedPos.isEmpty ||
          pos.any((p) => _selectedPos.contains(WordPos.fromString(p)));

      // Kiểm tra chữ cái đầu
      final containsLetter = _selectedLetter == null ||
          word.word.toLowerCase().startsWith(_selectedLetter!.toLowerCase());

      // Kiểm tra văn bản tìm kiếm
      final containsSearchText = _searchText.isEmpty ||
          word.word.toLowerCase().contains(_searchText.toLowerCase());

      // Trả về true nếu từ thỏa mãn tất cả điều kiện
      return containsPos && containsLetter && containsSearchText;
    }).toList();
  }

  _showWordDetails() {
    final notificationsBloc = context.read<NotificationsBloc>();
    final wordId =
        widget.wordId ?? notificationsBloc.state.wordIdFromNotification;
    if (wordId != null) {
      context
          .read<NotificationsBloc>()
          .add(const NotificationsEvent.clearWordIdFromNotification());
      final word = context.read<VocabularyBloc>().state.words.firstWhere(
            (element) => element.index == wordId,
          );
      context.push(RoutePaths.wordDetails, extra: {'word': word});
    }
  }

  void _listenNotificationsBloc() {
    final notificationsBloc = context.read<NotificationsBloc>();
    notificationsBloc.stream.listen((state) {
      if (state.wordIdFromNotification != null) {
        _showWordDetails();
      }
    });
  }

  _getFilterLabel() {
    final letter = _selectedLetter != null
        ? 'letter: ${_selectedLetter?.toLowerCase()}'
        : '';
    final pos = _selectedPos.isNotEmpty
        ? 'pos: ${_selectedPos.map((e) => e.name).join(', ')}'
        : '';
    final search = _searchText.isNotEmpty ? 'search: $_searchText' : '';
    if (letter.isEmpty && pos.isEmpty && search.isEmpty) {
      return 'Tất cả từ';
    }
    String result = '';
    if (letter.isNotEmpty) {
      result += letter;
    }
    if (pos.isNotEmpty) {
      if (result.isNotEmpty) {
        result += ', ';
      }
      result += pos;
    }
    if (search.isNotEmpty) {
      if (result.isNotEmpty) {
        result += ', ';
      }
      result += search;
    }
    return result;
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon,
      bool isSelected, VoidCallback onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon,
                color:
                    isSelected ? colorScheme.primary : colorScheme.onSurface),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
