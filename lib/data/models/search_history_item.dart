class SearchHistoryItem {
  final String word;
  final String pos;
  final DateTime searchedAt;

  SearchHistoryItem(
      {required this.word, required this.pos, required this.searchedAt});

  Map<String, dynamic> toJson() => {
        'word': word,
        'pos': pos,
        'searchedAt': searchedAt.toIso8601String(),
      };

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) =>
      SearchHistoryItem(
        word: json['word'],
        pos: json['pos'] ?? '',
        searchedAt: DateTime.parse(json['searchedAt']),
      );
}
