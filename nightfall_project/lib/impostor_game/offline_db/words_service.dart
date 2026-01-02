import 'data/words_lokacije.dart';
import 'data/words_hrana.dart';
import 'data/words_crtani.dart';

class Word {
  final int id;
  final String name;
  final int categoryId;
  final String hint;

  Word({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.hint,
  });
}

class WordsService {
  // Category IDs:
  // 1: Lokacije
  // 2: Hrana
  // 3: Crtani

  static final List<Word> _words = [
    ...lokacijeWords,
    ...hranaWords,
    ...crtaniWords,
  ];

  List<Word> getAllWords() {
    return _words;
  }

  List<Word> getWordsForCategory(int categoryId) {
    return _words.where((w) => w.categoryId == categoryId).toList();
  }

  int getWordCountForCategory(int categoryId) {
    return _words.where((w) => w.categoryId == categoryId).length;
  }
}
