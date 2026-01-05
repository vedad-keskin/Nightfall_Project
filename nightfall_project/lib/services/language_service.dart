import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  String _currentLanguage = 'en';

  LanguageService() {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    if (_currentLanguage == langCode) return;
    _currentLanguage = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, langCode);
    notifyListeners();
  }

  String translate(String key) {
    if (_currentLanguage == 'bs') {
      return _bsTranslations[key] ?? _enTranslations[key] ?? key;
    }
    return _enTranslations[key] ?? key;
  }

  static const Map<String, String> _enTranslations = {
    'mafia': 'MAFIA',
    'impostor': 'IMPOSTOR',
    'play_now': 'PLAY NOW',
    'back': 'BACK',
    'players_title': 'PLAYERS',
    'categories_title': 'CATEGORIES',
    'leaderboards_title': 'LEADERBOARDS',
    'hints_title': 'HINTS',
    'on': 'ON',
    'off': 'OFF',
    'game_on': 'GAME ON',
    'need_players_error': 'Need at least 3 players!',
    'no_categories_error': 'No categories selected!',
    'no_words_error': 'Selected category has no words!',
    'words_available': 'words available',
    'enter_name_hint': 'Enter name...',
    'add_button': 'ADD',
    'edit_name_title': 'EDIT NAME',
    'save_button': 'SAVE',
    'cancel_button': 'CANCEL',
    'select_categories_title': 'SELECT CATEGORIES',
    'words_count': 'words',
    'pass_device_title': 'PASS THE DEVICE',
    'waiting_players': 'Waiting for all players...',
    'game_start': 'GAME START',
    'secret_role': 'SECRET ROLE',
    'top_secret': 'TOP SECRET',
    'tap_to_flip': 'TAP TO FLIP',
    'understood_button': 'UNDERSTOOD',
    'you_are_the': 'YOU ARE THE',
    'word_is': 'THE WORD IS:',
    'category_label': 'CATEGORY:',
    'hint_label': 'HINT:',
    'discussion_time': 'DISCUSSION TIME',
    'inst_1': 'Go around in a circle for 2 or 3 rounds.',
    'inst_2': 'Each player must say ONE WORD related to their secret.',
    'inst_3': 'After rounds are over, you must vote for the IMPOSTOR!',
    'starting_player_label': 'STARTING PLAYER',
    'start_voting_button': 'START VOTING',
    'who_is_impostor': 'WHO IS THE IMPOSTOR?',
    'drag_suspect_here': 'DRAG SUSPECT HERE',
    'reveal_impostor_button': 'REVEAL IMPOSTOR',
    'vote_instruction': 'Drag a player to the box to vote',
    'verdict_title': 'THE VERDICT',
    'voted_as_impostor': 'VOTED AS IMPOSTOR:',
    'verdict_innocent': 'THEY WERE INNOCENT!',
    'verdict_impostor': 'THEY WERE THE IMPOSTOR!',
    'real_impostor_was': 'THE REAL IMPOSTOR WAS:',
    'secret_word': 'SECRET WORD',
    'impostor_escaped': 'THE IMPOSTOR ESCAPED!',
    'point_to': '+1 POINT TO',
    'innocents_win': 'INNOCENTS WIN!',
    'caught_impostor': 'You caught the Impostor!',
    'back_to_menu': 'BACK TO MENU',
    'reset_points_q': 'RESET POINTS?',
    'reset_undo_warn':
        'All player points will be set to zero. This cannot be undone.',
    'reset_button': 'RESET',
    'top_players_title': 'TOP PLAYERS',
    'no_players_found': 'No players found.',
    'how_to_play': 'RULES',
    'rules_impostor_title': 'HOW TO PLAY: IMPOSTOR',
    'rules_impostor_content':
        '1. Pass the device to each player so everyone can see their role and/or word.\n\n'
        '2. Roles:\n'
        '- One player is the IMPOSTOR.\n'
        '- The rest are INNOCENTS.\n\n'
        '3. Secret Word:\n'
        '- INNOCENTS see the secret word.\n'
        '- The IMPOSTOR only sees the category and, if enabled, a hint.\n'
        '- Hints are recommended for groups of 5 or fewer players. For larger groups, playing without hints is usually more fun.\n\n'
        '4. Taking Turns:\n'
        '- Players take turns in a circle, starting from the player chosen first by the game.\n'
        '- On your turn, say ONE word related to the secret word.\n'
        '- Words that are part of the secret word are usually not allowed unless agreed on beforehand.\n'
        '- If you don\'t know a word, you may Google it. The IMPOSTOR can also Google to mislead others.\n'
        '- Repeating words is not allowed.\n\n'
        '5. Voting:\n'
        '- After the 2nd or 3rd round, discuss and vote on who the IMPOSTOR is.\n'
        '- Voting can happen earlier if INNOCENTS are confident or if the IMPOSTOR gives themselves away.\n\n'
        '6. Winning the Game:\n'
        '- If the IMPOSTOR is caught, the INNOCENTS win.\n'
        '- If an INNOCENT is voted out, the IMPOSTOR wins and earns a point.\n'
        '- Points are tracked on the Leaderboard.\n\n'
        '7. Have Fun!\n'
        'Enjoy the game, be sneaky if you\'re the IMPOSTOR, and try to catch the IMPOSTOR if you\'re INNOCENT. Good luck!',
    'rules_mafia_title': 'HOW TO PLAY: MAFIA',
    'rules_mafia_content': 'Coming soon...',
  };

  static const Map<String, String> _bsTranslations = {
    'mafia': 'MAFIJA',
    'impostor': 'VARALICA',
    'play_now': 'ZAIGRAJ',
    'back': 'NAZAD',
    'players_title': 'IGRAČI',
    'categories_title': 'KATEGORIJE',
    'leaderboards_title': 'RANG-LISTA',
    'hints_title': 'HINTOVI',
    'on': 'UPALJENO',
    'off': 'UGAŠENO',
    'game_on': 'KRENI',
    'need_players_error': 'Potrebno je bar 3 igrača!',
    'no_categories_error': 'Kategorija nije odabrana!',
    'no_words_error': 'Odabrana kategorija nema riječi!',
    'words_available': 'riječi dostupno',
    'enter_name_hint': 'Unesi ime...',
    'add_button': 'DODAJ',
    'edit_name_title': 'UREDI IME',
    'save_button': 'SPASI',
    'cancel_button': 'ODUSTANI',
    'select_categories_title': 'ODABERITE KATEGORIJE',
    'words_count': 'riječi',
    'pass_device_title': 'PROSLIJEDI UREĐAJ',
    'waiting_players': 'Čekanje na sve igrače...',
    'game_start': 'ZAPOČNI',
    'secret_role': 'TAJNA ULOGA',
    'top_secret': 'STROGO POVJERLJIVO',
    'tap_to_flip': 'DODIRNI ZA OKRETANJE',
    'understood_button': 'RAZUMIJEM',
    'you_are_the': 'TI SI',
    'word_is': 'RIJEČ JE:',
    'category_label': 'KATEGORIJA:',
    'hint_label': 'TRAG:',
    'discussion_time': 'VRIJEME ZA DISKUSIJU',
    'inst_1': 'Idite u krug 2 ili 3 runde.',
    'inst_2': 'Svaki igrač mora reći JEDNU RIJEČ vezanu za tajnu.',
    'inst_3': 'Nakon rundi, izglasajte VARALICU!',
    'starting_player_label': 'POČETNI IGRAČ',
    'start_voting_button': 'ZAPOČNI GLASANJE',
    'who_is_impostor': 'KO JE VARALICA?',
    'drag_suspect_here': 'PREVUCI SUMNJIVCA OVDJE',
    'reveal_impostor_button': 'OTKRIJ VARALICU',
    'vote_instruction': 'Prevuci igrača u prostor za glasanje',
    'verdict_title': 'PRESUDA',
    'voted_as_impostor': 'GLASANO KAO VARALICA:',
    'verdict_innocent': 'BIO/LA JE NEVIN!',
    'verdict_impostor': 'BIO/LA JE VARALICA!',
    'real_impostor_was': 'PRAVA VARALICA JE BILA:',
    'secret_word': 'TAJNA RIJEČ',
    'impostor_escaped': 'VARALICA JE POBJEGLA!',
    'point_to': '+1 BOD ZA',
    'innocents_win': 'NEVINI POBJEĐUJU!',
    'caught_impostor': 'Uhvatili ste Varalicu!',
    'back_to_menu': 'NAZAD NA MENI',
    'reset_points_q': 'RESETUJ BODOVE?',
    'reset_undo_warn':
        'Svi bodovi će biti vraćeni na 0. Ovo se ne može poništiti.',
    'reset_button': 'RESETUJ',
    'top_players_title': 'NAJBOLJI IGRAČI',
    'no_players_found': 'Nema igrača.',
    'how_to_play': 'PRAVILA',
    'rules_impostor_title': 'PRAVILA: VARALICA',
    'rules_impostor_content':
        '1. Dodajte uređaj svakom igraču kako bi svi mogli vidjeti svoju ulogu i/ili riječ.\n\n'
        '2. Uloge:\n'
        '- Jedan igrač je VARALICA.\n'
        '- Ostali su NEVINI.\n\n'
        '3. Tajna riječ:\n'
        '- NEVINI vide tajnu riječ.\n'
        '- VARALICA vidi samo kategoriju i, ako je omogućeno, hintove.\n'
        '- Hintovi se preporučuju za grupe od 5 ili manje igrača. Za veće grupe, igranje bez hintova je obično zabavnije.\n\n'
        '4. Redoslijed:\n'
        '- Igrači naizmjenično igraju u krugu, počevši od igrača kojeg igra odredi kao prvog.\n'
        '- Na svom potezu recite JEDNU riječ povezanu s tajnom riječi.\n'
        '- Riječi koje su dio tajne riječi obično nisu dozvoljene osim ako se unaprijed ne dogovori.\n'
        '- Ako ne znate riječ, možete je potražiti na internetu. VARALICA također može pretraživati da bi zavarao druge.\n'
        '- Ponavljanje riječi nije dozvoljeno.\n\n'
        '5. Glasanje:\n'
        '- Nakon 2. ili 3. runde, raspravite i glasajte ko je VARALICA.\n'
        '- Glasanje se može obaviti i ranije ako NEVINI sigurno znaju ko je VARALICA ili ako se VARALICA preda.\n\n'
        '6. Pobjeda:\n'
        '- Ako je VARALICA uhvaćen, NEVINI pobjeđuju.\n'
        '- Ako je NEVIN izbačen, VARALICA pobjeđuje i dobija bod.\n'
        '- Bodovi se prate na Rang-listi.\n\n'
        '7. Zabavite se!\n'
        'Uživajte u igri, budite lukavi ako ste VARALICA i pokušajte uhvatiti VARALICU ako ste NEVINI. Sretno!',
    'rules_mafia_title': 'PRAVILA: MAFIJA',
    'rules_mafia_content': 'Uskoro dostupno...',
  };
}
