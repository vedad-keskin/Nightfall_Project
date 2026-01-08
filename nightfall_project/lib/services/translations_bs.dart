const Map<String, String> bsTranslations = {
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
      '- Igra zahtijeva Naratora koji upravlja tranzicijama i čita upute iz aplikacije.\n'
      '- Igrači su podijeljeni u dva glavna saveza: SELO i VUKOVI.\n'
      '- Mogu postojati i jedinstvene posebne uloge.\n\n'
      '3. Savezi i ciljevi:\n'
      '- SELO: Cilj je pronaći i eliminisati sve vukove. Pobjeđuju ako su svi vukovi eliminisani.\n'
      '- VUKOVI: Cilj je nadmašiti broj seljana. Pobjeđuju ako postignu omjer 1:1 ili bolji nad seljanima.\n'
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
      '- DOKTOR: Može izliječiti jednog igrača svake noći od smrti. Može izliječiti sebe, ali ne može izliječiti istu osobu dvije noći zaredom.\n'
      '- STRAŽAR: Može provjeriti jednog igrača svake noći. Narator mu daje znak rukom:\n'
      '  V = Seljanin, W = Vukodlak.\n'
      '  Luda i Vampir dobijaju znak V. Samo Vukodlaci i Osvetnički blizanac dobijaju znak W.\n'
      '- VRAČ: Može izliječiti igrača, ali postoji mala šansa da meta umre umjesto da bude izliječena.\n'
      '- BLIZANCI: Ako jedan Blizanac bude obješen, drugi postaje Osvetnički Blizanac koji pripada Vukodlacima.\n'
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
  'win_pts_label': 'WIN: {points} BOD',
  'tap_to_flip_card': 'DODIRNI KARTU ZA OKRETANJE',
  'villager_name': 'Seljak',
  'villager_desc': 'Obični mještanin koji pokušava preživjeti noć.',
  'werewolf_name': 'Vukodlak',
  'werewolf_desc':
      'Žestoki grabežljivac gladan seljana. Svake noći može ubiti jednog igrača. Pobjeđuju ako nadmaše selo.',
  'doctor_name': 'Doktor',
  'doctor_desc':
      'Posvećeni iscjelitelj. Svake noći može spasiti jednu osobu od napada te noći.',
  'guard_name': 'Stražar',
  'guard_desc': 'Budni zaštitnik. Svake noći može provjeriti jednog igrača.',
  'plague_doctor_name': 'Vrač',
  'plague_doctor_desc':
      'Misteriozni iscjelitelj. Svake noći može spasiti jednog igrača, ali ima i malu šansu da ga ubije.',
  'twins_name': 'Blizanci',
  'twins_desc':
      'Dvije povezane duše. Ako selo objesi jednog, drugi se pretvara u Osvetoljubivog blizanca koji pripada Vukovima. Ako vukovi ubiju jednog, drugi ostaje seljak.',
  'avenging_twin_name': 'Osvetoljubivi blizanac',
  'avenging_twin_desc':
      'Blizanac vođen osvetom. Kada mu selo objesi brata, on prihvaća tamu i pridružuje se vukovima.',
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
  'day_timer': 'TRAJANJE DANA',
  'timer_5_min': '5 MIN',
  'timer_10_min': '10 MIN',
  'timer_30s_p': '30s/I',
  'timer_infinity': '∞',
  'prepare_game_title': 'PRIPREMA IGRE',
  'players_count_label': 'IGRAČA: {count}',
  'selected_count_label': 'ODABRANO: {count}',
  'need_more_roles': 'POTREBNO JOŠ {count} ULOGA/E',
  'remove_roles': 'UKLONITE {count} ULOGU/E',
  'need_predator': 'POTREBAN BAR JEDAN VUKODLAK ILI VAMPIR',
  'too_many_predators': 'PREVIŠE VUKODLAKA / VAMPIRA',
  'proceed_button': 'NASTAVI',
  'tap_to_reveal': 'DODIRNI ZA OTKRIVANJE',
  'role_details_title': 'DETALJI ULOGE',
  'close_button': 'ZATVORI',
  'bound_soul_label': 'POVEZANA DUŠA:',
  'role_discovery_title': 'OTKRIVANJE ULOGA',
  'role_discovery_instruction':
      'PROSLIJEDI TELEFON IGRAČIMA DA OTKRIJU SVOJE ULOGE',
  'commence_night_button': 'ZAPOČNI NOĆ',
  'step_werewolves_title': 'VUKOVI I VAMPIR',
  'step_doctor_title': 'DOKTOR',
  'step_guard_title': 'STRAŽAR',
  'step_plague_doctor_title': 'VRAČ',
  'step_werewolves_instruction': 'ODABERI METU ZA ELIMINACIJU',
  'step_doctor_instruction': 'ODABERI METU ZA LIJEČENJE',
  'step_guard_instruction': 'ODABERI METU ZA PROVJERU',
  'step_plague_doctor_instruction': 'ODABERI METU (RIZIČNO LIJEČENJE)',
  'end_night_button': 'ZAVRŠI NOĆ',
  'next_step_button': 'SLJEDEĆI KORAK',
  'dawn_breaks_title': 'SVIĆE ZORA',
  'peaceful_night_msg': 'Bila je mirna noć.\nNiko nije umro.',
  'tragedy_struck_msg': 'Tragedija se dogodila!',
  'player_is_dead_label': '{name} JE MRTAV/A',
  'start_day_button': 'ZAPOČNI DAN',
  'the_pack_alliance_title': 'ČOPOR',
  'the_village_alliance_title': 'SELO',
  'specials_alliance_title': 'SPECIJALNE ULOGE',
  'doctor_saved_msg': 'Doktor je spasio igrača {name}!',
  'plague_doctor_saved_msg': 'Vrač je liječio igrača {name}... i preživio je!',
  'plague_doctor_failed_msg':
      'Vrač je pokušao pomoći igraču {name}... ali nije uspio.',
  'plague_doctor_killed_msg': 'Vračev tretman je bio fatalan za igrača {name}.',
  'winning_team_village': 'SELO',
  'winning_team_werewolves': 'VUKOVI',
  'winning_team_jester': 'LUDA',
  'game_over_title': 'KRAJ IGRE',
  'points_distributed_label': 'BODOVI DODIJELJENI',
  'no_points_awarded_msg': 'Nema dodijeljenih bodova.',
  'win_title': '{team} POBJEĐUJE/U!',
  'day_phase_title': 'DAN',
  'discuss_and_vote_instruction': 'RASPRAVA I GLASANJE',
  'hang_button': 'OBJESI',
  'skip_button': 'PRESKOČI',
  'select_button': 'ODABERI',
  'royal_guard_check': 'STRAŽAR // PROVJERA',
  'approaching': 'ŠUNJANJE...',
  'searching': 'PRETRAGA...',
  'looking_for_mark': 'TRAŽENJE ZNAKA...',
  'monster_found': 'ČUDOVIŠTE\nPRONAĐENO',
  'citizen_cleared': 'MJEŠTANIN\nČIST',
  'target_is_werewolf': 'Meta je VUK',
  'target_is_villager': 'Meta je SELJAK',
  'processing': 'OBRADA...',
  'investigate_button': 'PROVJERI',
};
