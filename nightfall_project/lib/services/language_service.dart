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
    'werewolves': 'WEREWOLVES',
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
    'rules_werewolves_title': 'HOW TO PLAY: WEREWOLVES',
    'rules_werewolves_content':
        '1. Pass the device to each player so everyone can see their role.\n\n'
        '2. Setup:\n'
        '- The game requires a Narrator who manages the transitions and reads instructions from the app.\n'
        '- Players are divided into two main alliances: THE VILLAGE and THE WEREWOLVES.\n'
        '- There may also be unique special roles.\n\n'
        '3. Alliances and Goals:\n'
        '- VILLAGE: Goal is to find and eliminate all werewolves. They win if all werewolves are dead.\n'
        '- WEREWOLVES: Goal is to outnumber the villagers. They win if they achieve a 1:1 or better ratio with villagers.\n'
        '- JESTER (Neutral): Wins ONLY if they are voted out by the village during the Day Phase.\n\n'
        '4. The Night Phase:\n'
        '- Everyone closes their eyes.\n'
        '- The Narrator calls specific roles to wake up and perform their actions via the app (e.g., werewolves choosing a victim, doctor saving someone).\n\n'
        '5. The Day Phase:\n'
        '- The Narrator announces who was killed during the Night (if anyone).\n'
        '- Dead players must remain silent and cannot vote.\n'
        '- Discussion: Surviving players discuss who they think the werewolves are.\n'
        '- A timer for the duration of the day can be set when creating the game.\n'
        '  It does not force the vote or skip it; it only serves as a reminder for the Narrator\n'
        '  that discussion time is over and that he should prompt players to vote or skip the voting.\n'
        '- Voting: Players can vote to hang a suspect. The player with the most votes is eliminated.\n'
        '- The Village is not required to hang a player each day.\n'
        '- In case of a tie, no one is hanged.\n\n'
        '6. Character Abilities:\n'
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
        '7. Scoring:\n'
        '- Points are awarded to members of the winning alliance at the end of the game.\n'
        '- Different roles grant different amounts of points depending on their difficulty.\n\n'
        'Enjoy the mystery and deception. Good luck!',
    'werewolf_game': 'WEREWOLVES GAME',
    'roles_title': 'ROLES',
    'pts': 'pts',
    'alliance_label': 'ALLIANCE',
    'win_pts_label': 'WIN: {points} PTS',
    'tap_to_flip_card': 'TAP CARD TO FLIP',
    'villager_name': 'Villager',
    'villager_desc': 'A simple townsperson trying to survive the night.',
    'werewolf_name': 'Werewolf',
    'werewolf_desc':
        'A fierce predator hungry for villagers. Each night, they can kill one player. Wins if they outnumber the village.',
    'doctor_name': 'Doctor',
    'doctor_desc':
        'A dedicated healer. Each night, she can save one person from being attacked that night.',
    'guard_name': 'Guard',
    'guard_desc':
        'A vigilant protector. Each night, he can inspect one player.',
    'plague_doctor_name': 'Plague Doctor',
    'plague_doctor_desc':
        'A mysterious healer. Each night, he can save one player but also has a small chance to kill him.',
    'twins_name': 'Twins',
    'twins_desc':
        'Two souls bound together. If one is hanged by the village, the other becomes an Avenging Twin. If one is killed by a werewolf, the other remains a villager.',
    'avenging_twin_name': 'Avenging Twin',
    'avenging_twin_desc':
        'A twin fueled by vengeance. When their sibling is hanged by the village, they embrace the darkness and join the werewolves.',
    'vampire_name': 'Vampire',
    'vampire_desc':
        'A dark creature of the night. Awakens and kills with the werewolves each night, but remains undetected by the Guard.',
    'jester_name': 'Jester',
    'jester_desc':
        'A silly trickster. Wants to be hanged by the village to claim victory.',
    'villagers_alliance_name': 'Villagers',
    'villagers_alliance_desc':
        'The peaceful inhabitants of the village. Their goal is to find and eliminate all werewolves.',
    'werewolves_alliance_name': 'Werewolves',
    'werewolves_alliance_desc':
        'The predators of the night. Their goal is to outnumber the villagers to take over the town.',
    'jester_alliance_name': 'Jester',
    'jester_alliance_desc':
        'A chaotic soul who wins only if they are voted out by the village during the day.',
  };

  static const Map<String, String> _bsTranslations = {
    'werewolves': 'VUKOVI',
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
    'rules_werewolves_title': 'PRAVILA: VUKOVI',
    'rules_werewolves_content':
        '1. Proslijedite uređaj svakom igraču kako bi svi mogli vidjeti svoju ulogu.\n\n'
        '2. Postavka:\n'
        '- Igra zahtijeva Naratora koji upravlja prijelazima i čita upute iz aplikacije.\n'
        '- Igrači su podijeljeni u dva glavna saveza: SELO i VUKOVI.\n'
        '- Mogu postojati i jedinstvene posebne uloge.\n\n'
        '3. Savezi i ciljevi:\n'
        '- SELO: Cilj je pronaći i eliminisati sve vukove. Pobjeđuju ako su svi vukovi mrtvi.\n'
        '- VUKOVI: Cilj je nadmašiti broj seljana. Pobjeđuju ako postignu omjer 1:1 ili bolji sa seljanima.\n'
        '- JESTER (Neutralni): Pobjeđuje SAMO ako bude izglasan od strane sela tokom dnevne faze.\n\n'
        '4. Noćna faza:\n'
        '- Svi zatvaraju oči.\n'
        '- Narator poziva određene uloge da se probude i izvrše svoje radnje putem aplikacije (npr. vukovi biraju žrtvu, doktor spašava nekoga).\n\n'
        '5. Dnevna faza:\n'
        '- Narator objavljuje ko je ubijen tokom noći (if anyone).\n'
        '- Mrtvi igrači moraju šutjeti i ne mogu glasati.\n'
        '- Rasprava: Preživjeli igrači raspravljaju o tome ko su vukovi.\n'
        '- Može se postaviti tajmer za trajanje dnevne faze prilikom kreiranja igre.\n'
        '  Tajmer ne prisiljava glasanje niti njegovo preskakanje; služi samo kao podsjetnik\n'
        '  Naratoru da je vrijeme za raspravu isteklo i da treba potaknuti igrače da glasaju ili preskoče glasanje.\n'
        '- Glasanje: Igrači mogu glasati za vješanje sumnjivca. Igrač sa najviše glasova se eliminiše.\n'
        '- Selo nije obavezno objesiti igrača svaki dan.\n'
        '- U slučaju izjednačenja, niko ne biva obješen.\n\n'
        '6. Sposobnosti likova:\n'
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
        '7. Bodovanje:\n'
        '- Bodovi se dodjeljuju članovima pobjedničkog saveza na kraju igre.\n'
        '- Različite uloge daju različite iznose bodova ovisno o njihovoj težini.\n\n'
        'Uživajte u misteriji i obmani. Sretno!',
    'werewolf_game': 'IGRA VUKOVA',
    'roles_title': 'ULOGE',
    'pts': 'bod',
    'alliance_label': 'SAVEZ',
    'win_pts_label': 'POBJEDA: {points} BOD',
    'tap_to_flip_card': 'DODIRNI KARTU ZA OKRETANJE',
    'villager_name': 'Seljak',
    'villager_desc': 'Obični mještanin koji pokušava preživjeti noć.',
    'werewolf_name': 'Vuk',
    'werewolf_desc':
        'Žestoki grabežljivac gladan seljana. Svake noći mogu ubiti jednog igrača. Pobjeđuju ako nadmaše selo.',
    'doctor_name': 'Doktor',
    'doctor_desc':
        'Posvećeni iscjelitelj. Svake noći može spasiti jednu osobu od napada te noći.',
    'guard_name': 'Stražar',
    'guard_desc': 'Budni zaštitnik. Svake noći može provjeriti jednog igrača.',
    'plague_doctor_name': 'Kužni doktor',
    'plague_doctor_desc':
        'Misteriozni iscjelitelj. Svake noći može spasiti jednog igrača, ali ima i malu šansu da ga ubije.',
    'twins_name': 'Blizanci',
    'twins_desc':
        'Dvije duše povezane zajedno. Ako sela objesi jednog, drugi se pretvara u vuka. Ako vukovi ubiju jednog, drugi ostaje seljak.',
    'avenging_twin_name': 'Osvetoljubivi blizanac',
    'avenging_twin_desc':
        'Blizanac vođen osvetom. Kada im selo objesi brata/sestru, oni prihvaćaju tamu i pridružuju se vukovima.',
    'vampire_name': 'Vampir',
    'vampire_desc':
        'Mračno stvorenje noći. Budi se i ubija s vukovima svake noći, ali ostaje neotkriven od strane Stražara.',
    'jester_name': 'Luda',
    'jester_desc':
        'Smiješni šaljivdžija. Želi da ga selo objesi kako bi proglasio pobjedu.',
    'villagers_alliance_name': 'Seljani',
    'villagers_alliance_desc':
        'Mirni stanovnici sela. Njihov cilj je pronaći i eliminisati sve vukove.',
    'werewolves_alliance_name': 'Vukovi',
    'werewolves_alliance_desc':
        'Grabežljivci noći. Njihov cilj je nadmašiti broj seljana kako bi preuzeli grad.',
    'jester_alliance_name': 'Luda',
    'jester_alliance_desc':
        'Haočna duša koja pobjeđuje samo ako bude izglasana od strane sela tokom dana.',
  };
}
