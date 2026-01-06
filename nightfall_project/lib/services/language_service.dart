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
    'mafia': 'WEREWOLVES',
    'impostor': 'IMPOSTOR',
    'impostor-game': 'IMPOSTOR GAME',
    'play_now': 'PLAY NOW',
    'back': 'BACK',
    'players_title': 'PLAYERS',
    'categories_title': 'CATEGORIES',
    'leaderboards_title': 'LEADERBOARDS',
    'hints_title': 'HINTS',
    'on': 'ON',
    'off': 'OFF',
    'game_on': 'START GAME',
    'need_at_least_3_players': 'NEED AT LEAST 3 PLAYERS',
    'need_at_least_5_players': 'NEED AT LEAST 5 PLAYERS',
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
    'rules_mafia_title': 'HOW TO PLAY: WEREWOLVES',
    'rules_mafia_content':
        '1. Setup:\n'
        '- Pass the device to each player so they can secretly see their role.\n\n'
        '2. Roles & Alliances:\n'
        '- VILLAGE: Villagers, Doctor, Guard, Plague Doctor, Twins.\n'
        '  Goal: Eliminate all Werewolves.\n'
        '- WEREWOLVES: Werewolves, Vampire, Avenging Twin.\n'
        '  Goal: Win when the number of Werewolves is equal to or greater than the number of Villagers.\n'
        '- SPECIAL: Jester.\n'
        '  Goal: Be hanged by the Village.\n\n'
        '3. Night Phase:\n'
        '- The game is played in rounds, starting with Night.\n'
        '- Werewolves secretly choose one player to kill.\n'
        '- Special roles perform their abilities.\n\n'
        '4. Day Phase:\n'
        '- The result of the Night is revealed.\n'
        '- Dead players are removed from the game and may no longer speak.\n'
        '- Players discuss openly and vote to hang one player.\n'
        '- The player with the most votes is hanged.\n'
        '- The Village is not required to hang a player each day.\n'
        '- In case of a tie, no one is hanged.\n\n'
        '5. Character Abilities:\n'
        '- WEREWOLF: Chooses a victim each night together with other Werewolves.\n'
        '- VILLAGER: Has no special ability; relies on discussion and voting.\n'
        '- VAMPIRE: Awakens with the Werewolves but appears as a Villager when inspected.\n'
        '- DOCTOR: Can protect one player each night from being killed. May protect himself, but cannot protect the same person two nights in a row.\n'
        '- GUARD: Can inspect one player each night. The Narrator gives a hand sign:\n'
        '  V = Villager, W = Werewolf.\n'
        '  Jesters and Vampires receive the V sign. Only Werewolves and the Avenging Twin receive the W sign.\n'
        '- PLAGUE DOCTOR: Can protect a player, but there is a small chance the target dies instead.\n'
        '- TWINS: If one Twin is hanged, the other becomes a Werewolf.\n'
        '  If one Twin is killed at night, the other remains a Villager.\n'
        '- AVENGING TWIN: If their Twin dies, they become an Avenging Twin and wake up with the Werewolves from the next night forward.\n'
        '- JESTER: Wins immediately only if hanged by the Village.\n\n'
        '6. Winning:\n'
        '- Village wins if all Werewolves are eliminated.\n'
        '- Werewolves win if they equal or outnumber the Village.\n'
        '- Jester wins instantly only if hanged.\n'
        '- Points are awarded to the winning players based on role difficulty.\n',
  };

  static const Map<String, String> _bsTranslations = {
    'mafia': 'VUKOVI',
    'impostor': 'VARALICA',
    'impostor-game': 'VARALICA',
    'play_now': 'ZAIGRAJ',
    'back': 'NAZAD',
    'players_title': 'IGRAČI',
    'categories_title': 'KATEGORIJE',
    'leaderboards_title': 'RANG-LISTA',
    'hints_title': 'HINTOVI',
    'on': 'UPALJENO',
    'off': 'UGAŠENO',
    'game_on': 'KRENI',
    'need_at_least_3_players': 'POTREBNO JE BAR 3 IGRAČA',
    'need_at_least_5_players': 'POTREBNO JE BAR 5 IGRAČA',
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
    'rules_mafia_title': 'PRAVILA: VUKOVI',
    'rules_mafia_content':
        '1. Postavka:\n'
        '- Proslijedite uređaj svakom igraču kako bi tajno vidio svoju ulogu.\n\n'
        '2. Uloge i savezi:\n'
        '- SELO: Seljani, Doktor, Stražar, Vrač, Blizanci.\n'
        '  Cilj: Eliminisati sve Vukodlake.\n'
        '- VUKODLACI: Vukodlaci, Vampir, Osvetnički blizanac.\n'
        '  Cilj: Pobjeđuju kada je broj Vukodlaka jednak ili veći od broja Seljana.\n'
        '- POSEBNA ULOGA: Luda.\n'
        '  Cilj: Pobjeđuje kada je obješen od strane Sela.\n\n'
        '3. Noćna faza:\n'
        '- Igra se odvija u rundama koje započinju noću.\n'
        '- Vukodlaci tajno biraju jednog igrača kojeg žele ubiti.\n'
        '- Posebne uloge izvršavaju svoje sposobnosti.\n\n'
        '4. Dnevna faza:\n'
        '- Objavljuju se rezultati noći.\n'
        '- Mrtvi igrači se uklanjaju iz igre i nemaju pravo govoriti nakon smrti.\n'
        '- Preživjeli igrači otvoreno raspravljaju i glasaju za vješanje jednog igrača.\n'
        '- Igrač sa najviše glasova biva obješen.\n'
        '- Selo nije obavezno objesiti igrača svaki dan.\n'
        '- U slučaju izjednačenja, niko ne biva obješen.\n\n'
        '5. Sposobnosti likova:\n'
        '- VUKODLAK: Zajedno s ostalim Vukodlacima svake noći bira žrtvu.\n'
        '- SELJANIN: Nema posebnu sposobnost; oslanja se na raspravu i glasanje.\n'
        '- VAMPIR: Budi se s Vukodlacima, ali se pri provjeri prikazuje kao Seljanin.\n'
        '- DOKTOR: Može zaštititi jednog igrača svake noći od smrti. Može zaštititi sebe, ali ne može štititi istu osobu dvije noći zaredom.\n'
        '- STRAŽAR: Može provjeriti jednog igrača svake noći. Narator mu daje znak rukom:\n'
        '  V = Seljanin, W = Vukodlak.\n'
        '  Luda i Vampir dobijaju znak V. Samo Vukodlaci i Osvetnički blizanac dobijaju znak W.\n'
        '- VRAČ: Može zaštititi igrača, ali postoji mala šansa da meta umre umjesto da bude spašena.\n'
        '- BLIZANCI: Ako jedan Blizanac bude obješen, drugi postaje Vukodlak.\n'
        '  Ako jedan Blizanac bude ubijen tokom noći, drugi ostaje Seljanin.\n'
        '- OSVETNIČKI BLIZANAC: Ako njegov Blizanac umre, postaje Osvetnički blizanac i od sljedeće noći se budi s Vukodlacima.\n'
        '- LUDA: Pobjeđuje samo ako bude obješena od strane Sela.\n\n'
        '6. Pobjeda:\n'
        '- Selo pobjeđuje ako su svi Vukodlaci eliminisani.\n'
        '- Vukodlaci pobjeđuju ako izjednače ili nadjačaju broj Seljana.\n'
        '- Luda pobjeđuje samo ako bude obješen.\n'
        '- Bodovi se dodjeljuju pobjednicima na osnovu težine uloge.\n',
  };
}
