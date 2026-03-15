// ── Web-app translation keys ───────────────────────────────────────────────
export type TranslationKey =
    // Navbar
    | 'nav_roles' | 'nav_rulebook'
    // Roles page header
    | 'roles_page_title' | 'roles_page_subtitle'
    // Alliance names & descriptions
    | 'villagers_alliance_name' | 'villagers_alliance_desc'
    | 'werewolves_alliance_name' | 'werewolves_alliance_desc'
    | 'specials_alliance_name' | 'specials_alliance_desc'
    // UI labels
    | 'tap_to_reveal' | 'win_pts_label' | 'win_variable' | 'pts'
    // Gambler note
    | 'gambler_points_note'
    // Puppet Master note
    | 'puppet_master_points_note'
    // Role names
    | 'villager_name' | 'doctor_name' | 'guard_name' | 'plague_doctor_name'
    | 'twins_name' | 'knight_name' | 'executioner_name' | 'infected_name'
    | 'drunk_name' | 'shaman_name' | 'wraith_name'
    | 'werewolf_name' | 'avenging_twin_name' | 'vampire_name' | 'dire_wolf_name'
    | 'jester_name' | 'puppet_master_name' | 'gambler_name'
    // Role descriptions
    | 'villager_desc' | 'doctor_desc' | 'guard_desc' | 'plague_doctor_desc'
    | 'twins_desc' | 'knight_desc' | 'executioner_desc' | 'infected_desc'
    | 'drunk_desc' | 'shaman_desc' | 'wraith_desc'
    | 'werewolf_desc' | 'avenging_twin_desc' | 'vampire_desc' | 'dire_wolf_desc'
    | 'jester_desc' | 'puppet_master_desc' | 'gambler_desc'
    // Rulebook page
    | 'rulebook_page_title' | 'rulebook_page_subtitle'
    | 'rulebook_toc_title' | 'rulebook_page_label' | 'on' | 'off' | 'back' | 'next_step_button'
    // Rulebook section titles
    | 'rule_distribution_title' | 'rule_setup_title' | 'rule_alliances_title'
    | 'rule_night_title' | 'rule_day_title' | 'rule_abilities_title'
    | 'rule_scoring_title'
    // Rulebook paragraphs — distribution
    | 'rule_dist_p1' | 'rule_dist_p2'
    // setup
    | 'rule_setup_p1' | 'rule_setup_p2' | 'rule_setup_p3' | 'rule_setup_p4'
    // alliances
    | 'rule_all_p1' | 'rule_all_p2' | 'rule_all_p3'
    // night
    | 'rule_night_p1' | 'rule_night_p2' | 'rule_night_p3' | 'rule_night_p4' | 'rule_night_p5'
    // day
    | 'rule_day_p1' | 'rule_day_p2' | 'rule_day_p3' | 'rule_day_p4'
    | 'rule_day_p5' | 'rule_day_p6' | 'rule_day_p7' | 'rule_day_p8'
    // abilities
    | 'rule_ab_werewolf' | 'rule_ab_villager' | 'rule_ab_vampire'
    | 'rule_ab_doctor' | 'rule_ab_guard' | 'rule_ab_plague_doctor'
    | 'rule_ab_twins' | 'rule_ab_avenging_twin' | 'rule_ab_jester'
    | 'rule_ab_drunk' | 'rule_ab_knight' | 'rule_ab_puppet_master'
    | 'rule_ab_executioner' | 'rule_ab_infected' | 'rule_ab_gambler'
    | 'rule_ab_shaman' | 'rule_ab_wraith' | 'rule_ab_dire_wolf'
    // scoring
    | 'rule_score_p1' | 'rule_score_p2' | 'rule_score_p3'
    | 'rule_score_p4' | 'rule_score_p5'
    // Footer
    | 'footer_text';

// ── English ────────────────────────────────────────────────────────────────
export const EN: Record<TranslationKey, string> = {
    nav_roles: 'ROLES',
    nav_rulebook: 'RULEBOOK',

    roles_page_title: 'ROLES',
    roles_page_subtitle: 'Learn about every character in the game',

    villagers_alliance_name: 'The Village',
    villagers_alliance_desc: 'The peaceful inhabitants of the village. Their goal is to find and eliminate all werewolves.',
    werewolves_alliance_name: 'The Werewolves',
    werewolves_alliance_desc: 'The predators of the night. Their goal is to outnumber the villagers to take over the town.',
    specials_alliance_name: 'Specials',
    specials_alliance_desc: 'Independent roles with unique win conditions and special abilities.',

    tap_to_reveal: 'TAP TO REVEAL',
    win_pts_label: 'WIN:',
    win_variable: 'WIN: ?',
    pts: 'PTS',

    gambler_points_note: '+1 Village, +2 Werewolves, +3 Specials',
    puppet_master_points_note: 'Inherits points from transformed role',

    villager_name: 'Villager',
    doctor_name: 'Doctor',
    guard_name: 'Guard',
    plague_doctor_name: 'Plague Doctor',
    twins_name: 'Twins',
    knight_name: 'Knight',
    executioner_name: 'Executioner',
    infected_name: 'Infected',
    drunk_name: 'Drunk',
    shaman_name: 'Shaman',
    wraith_name: 'Wraith',
    werewolf_name: 'Werewolf',
    avenging_twin_name: 'Avenging Twin',
    vampire_name: 'Vampire',
    dire_wolf_name: 'Dire Wolf',
    jester_name: 'Jester',
    puppet_master_name: 'Puppet Master',
    gambler_name: 'Gambler',

    villager_desc: 'A simple townsperson trying to survive the night.',
    doctor_desc: 'A dedicated healer. Each night, she can save one person from being attacked that night.',
    guard_desc: 'A vigilant protector. Each night, he can inspect one player.',
    plague_doctor_desc: 'A mysterious healer. Each night, he can save one player but also has a small chance to kill him.',
    twins_desc: 'Two souls bound together. If one is hanged by the village, the other becomes an Avenging Twin. If one is killed by a werewolf, the other remains a villager.',
    knight_desc: 'A brave warrior. He has armor that protects him from the first lethal attack. He only dies if attacked a second time.',
    executioner_desc: 'A vengeful villager. If hanged by the village, he can take one player with him to the grave.',
    infected_desc: 'A villager carrying a hidden sickness. If the Doctor heals them, the Doctor gets infected and dies. If the werewolves target them at night while they have a vampire in their team, the vampire gets infected and dies.',
    drunk_desc: 'A confused drinker. Due to intoxication, he appears as a Werewolf to the Guard, but is actually a loyal Villager.',
    shaman_desc: 'A mystical seer who communes with the spirits. Every second night, the Shaman can inspect one player and learn their true role. Unlike the Guard, the Shaman sees through all disguises.',
    wraith_desc: 'A restless spirit bound to the village. The Wraith cannot be killed by any means — not by werewolves, plague, hanging, or execution. It lingers eternally, watching over the living.',
    werewolf_desc: 'A fierce predator hungry for villagers. Each night, they can kill one player. Wins if they outnumber the village.',
    avenging_twin_desc: 'A twin fueled by vengeance. When their sibling is hanged by the village, they embrace the darkness and join the werewolves.',
    vampire_desc: 'A dark creature of the night. Awakens and kills with the werewolves each night, but remains undetected by the Guard.',
    dire_wolf_desc: 'A terrifying alpha predator. Hunts with the pack, then wakes alone every other night to silence one player, preventing them from using their ability the following night.',
    jester_desc: 'A silly trickster. Wants to be hanged by the village to claim victory.',
    puppet_master_desc: 'A mysterious observer. Transforms into the role of the first person who gets hanged by the village.',
    gambler_desc: 'A cunning risk-taker who bets on fate. On the first night, they secretly choose which alliance they believe will win. If correct, they share in the victory points. Behaves as a normal villager otherwise.',

    rulebook_page_title: 'RULEBOOK',
    rulebook_page_subtitle: 'How to play Nightfall: Werewolves',
    rulebook_toc_title: 'CONTENTS',
    rulebook_page_label: 'PAGE',
    on: 'OF',
    off: 'OFF',
    back: 'BACK',
    next_step_button: 'NEXT',

    rule_distribution_title: '1. Role Distribution',
    rule_setup_title: '2. Setup',
    rule_alliances_title: '3. Alliances and Goals',
    rule_night_title: '4. The Night Phase',
    rule_day_title: '5. The Day Phase',
    rule_abilities_title: '6. Character Abilities',
    rule_scoring_title: '7. Scoring',

    rule_dist_p1: 'Pass the device to each player individually so they can view their role in secret.',
    rule_dist_p2: 'Players must confirm they have seen and understood their role before passing the device to the next player.',

    rule_setup_p1: 'One player needs to be the Narrator. The Narrator does not participate as a character and cannot be killed or voted out.',
    rule_setup_p2: 'The Narrator controls the flow of the game and follows instructions provided by the app.',
    rule_setup_p3: 'Players are randomly assigned roles belonging to one of the main alliances: THE VILLAGE or THE WEREWOLVES.',
    rule_setup_p4: 'Some players may receive unique special roles with additional abilities.',

    rule_all_p1: 'THE VILLAGE: Wins if all Werewolves are eliminated.',
    rule_all_p2: 'THE WEREWOLVES: Win if they reach a point where the number of Werewolves is equal to or greater than the number of remaining Villagers.',
    rule_all_p3: 'THE SPECIALS: They have their own special winning conditions.',

    rule_night_p1: 'All players close their eyes and remain silent.',
    rule_night_p2: 'The Narrator wakes specific roles one by one, following the order shown in the app.',
    rule_night_p3: 'When a role is awake, players use silent gestures only. To execute their ability, they point their finger at the chosen player.',
    rule_night_p4: 'The Narrator acknowledges the choice and instructs the role to return to sleep.',
    rule_night_p5: 'No speaking, sounds, or discussion are allowed during the Night Phase.',

    rule_day_p1: 'The Narrator announces the outcome of the Night (who was killed, if anyone).',
    rule_day_p2: 'Eliminated players must remain silent for the rest of the game and may not vote.',
    rule_day_p3: 'Discussion: All surviving players may freely discuss and accuse others.',
    rule_day_p4: 'A discussion timer may be set when creating the game. The timer serves only as a reminder for the Narrator to move the game forward.',
    rule_day_p5: 'Voting: Players may vote to eliminate a suspect by pointing at them.',
    rule_day_p6: 'A player is hanged and eliminated only if they receive more than half of the votes from all living players.',
    rule_day_p7: 'Voting may be skipped.',
    rule_day_p8: 'If no player receives a strict majority, or in case of a tie, no player is eliminated.',

    rule_ab_werewolf: 'WEREWOLF: Awakens at night with other Werewolves and collectively chooses one victim to kill.',
    rule_ab_villager: 'VILLAGER: Has no special ability. Relies on discussion, logic, and voting.',
    rule_ab_vampire: 'VAMPIRE: Awakens with the Werewolves but appears as a Villager when inspected. Can be killed when targeting the Infected.',
    rule_ab_doctor: 'DOCTOR: Chooses one player each night to protect from being killed. May protect themselves. Cannot protect the same player on two consecutive nights.',
    rule_ab_guard: 'GUARD: Inspects one player each night. The Narrator privately shows the inspection result on their device to the Guard. Inspection Result: VILLAGER – All types of Villagers, Vampires, and Jesters. WEREWOLF – Werewolves, Drunks, and the Avenging Twin.',
    rule_ab_plague_doctor: 'PLAGUE DOCTOR: Can protect one player at night, but there is a small chance the target dies instead. May protect themselves. Cannot protect the same player on two consecutive nights.',
    rule_ab_twins: 'TWINS: If one Twin is hanged during the Day Phase, the other immediately becomes a Werewolf. If one Twin is killed during the Night Phase, the other remains a Villager.',
    rule_ab_avenging_twin: 'AVENGING TWIN: If their Twin is hanged, they transform into an Avenging Twin. From the next night onward, they awaken and act with the Werewolves.',
    rule_ab_jester: 'JESTER: Wins instantly and alone if eliminated by Village vote during the Day Phase.',
    rule_ab_drunk: 'DRUNK: Has no special ability and behaves as a normal Villager. When inspected by the Guard, the Drunk is suspicious and appears as a Werewolf.',
    rule_ab_knight: 'KNIGHT: A Villager with two lives, one protected by armor. First life (Armor): Cannot be healed by the Doctor or Plague Doctor. The armor can be destroyed by a Werewolf attack or a Plague Doctor accidental kill. If both attacks happen on the same night, the Knight dies immediately. Second life: Can be killed by Werewolves or a Plague Doctor accidental kill. The second life can be saved by either the Doctor or the Plague Doctor. Hanging kills him immediately.',
    rule_ab_puppet_master: 'PUPPET MASTER: Starts the game as a normal Villager. When the first hanging of the game occurs, the Puppet Master transforms into the role of the hanged player. The hanged player is eliminated normally. If the Jester is hanged, the Jester wins immediately and no Puppet Master transformation occurs. If the Gambler is hanged, the Puppet Master inherits the bet.',
    rule_ab_executioner: 'EXECUTIONER: A vengeful villager. If hanged by the village, he can take one player with him to the grave.',
    rule_ab_infected: 'INFECTED: A villager carrying a hidden sickness. If the Doctor heals them, the Doctor gets infected and dies. If targeted by the Werewolves with a Vampire, the Vampire gets infected and dies too.',
    rule_ab_gambler: 'GAMBLER: A cunning risk-taker. On the first night only, the Gambler secretly chooses which alliance they believe will win. After placing their bet, they behave as a normal Villager. If correct, they earn bonus points: +1 for Village, +2 for Werewolves, +3 for Specials.',
    rule_ab_shaman: "SHAMAN: A mystical seer who communes with the spirits. Every second night (2nd, 4th, 6th…), the Shaman wakes up last and can inspect one player. Unlike the Guard, the Shaman sees the player's true role. The Shaman cannot inspect himself.",
    rule_ab_wraith: 'WRAITH: A restless spirit bound to the village. The Wraith cannot be killed by any means — not by werewolves, plague, hanging, or execution. It lingers eternally, watching over the living.',
    rule_ab_dire_wolf: 'DIRE WOLF: A terrifying alpha. Hunts with the Werewolves each night. Every other night the Dire Wolf wakes alone to silence one player, preventing them from using their ability the following night.',

    rule_score_p1: 'Points are awarded to members of the winning alliance at the end of the game.',
    rule_score_p2: 'Different roles grant different amounts of points depending on their difficulty.',
    rule_score_p3: 'Full point distributions can be found in the Roles section of the game.',
    rule_score_p4: 'Special roles do not belong to an alliance and instead have their own winning conditions.',
    rule_score_p5: 'Enjoy the mystery and deception. Good luck!',

    footer_text: 'NIGHTFALL PROJECT © 2025',
};

// ── Bosnian ────────────────────────────────────────────────────────────────
export const BS: Record<TranslationKey, string> = {
    nav_roles: 'ULOGE',
    nav_rulebook: 'PRAVILA',

    roles_page_title: 'ULOGE',
    roles_page_subtitle: 'Upoznajte sve likove iz igre',

    villagers_alliance_name: 'Seljani',
    villagers_alliance_desc: 'Mirni stanovnici sela. Njihov cilj je pronaći i eliminisati sve vukove.',
    werewolves_alliance_name: 'Vukovi',
    werewolves_alliance_desc: 'Grabežljivci noći. Njihov cilj je nadmašiti broj seljana kako bi preuzeli grad.',
    specials_alliance_name: 'Posebni',
    specials_alliance_desc: 'Jedinstvene uloge sa specijalnim uslovima pobjede i posebnim sposobnostima.',

    tap_to_reveal: 'DODIRNI ZA OTKRIVANJE',
    win_pts_label: 'POBJEDA:',
    win_variable: 'POBJEDA: ?',
    pts: 'BOD/A',

    gambler_points_note: '+1 Seljani, +2 Vukovi, +3 Posebni',
    puppet_master_points_note: 'Nasljeđuje bodove transformisane uloge',

    villager_name: 'Seljak',
    doctor_name: 'Doktor',
    guard_name: 'Stražar',
    plague_doctor_name: 'Vrač',
    twins_name: 'Blizanci',
    knight_name: 'Vitez',
    executioner_name: 'Dželat',
    infected_name: 'Zaražena',
    drunk_name: 'Pijanica',
    shaman_name: 'Šaman',
    wraith_name: 'Utvara',
    werewolf_name: 'Vukodlak',
    avenging_twin_name: 'Osvetnički Blizanac',
    vampire_name: 'Vampir',
    dire_wolf_name: 'Zli Vuk',
    jester_name: 'Luda',
    puppet_master_name: 'Lutkar',
    gambler_name: 'Kockar',

    villager_desc: 'Obični mještanin koji pokušava preživjeti noć.',
    doctor_desc: 'Posvećeni iscjelitelj. Svake noći može spasiti jednu osobu od napada te noći.',
    guard_desc: 'Budni zaštitnik. Svake noći može provjeriti jednog igrača.',
    plague_doctor_desc: 'Misteriozni iscjelitelj. Svake noći može spasiti jednog igrača, ali ima i malu šansu da ga ubije.',
    twins_desc: 'Dvije povezane duše. Ako selo objesi jednog, drugi se pretvara u Osvetničkog blizanca. Ako vukovi ubiju jednog, drugi ostaje seljak.',
    knight_desc: 'Hrabri ratnik. Ima oklop koji ga štiti od prvog smrtonosnog napada. Umire samo ako bude napadnut drugi put.',
    executioner_desc: 'Osvetoljubivi seljak. Ako bude obješen od strane sela, može povesti jednog igrača sa sobom u grob.',
    infected_desc: 'Seljak koji nosi skrivenu bolest. Ako ga Doktor izliječi, Doktor se zarazi i umire. Ako ga vukovi ciljaju noću dok imaju Vampira u timu, Vampir se zarazi i umire.',
    drunk_desc: 'Zbunjeni pijanac. Zbog opijenosti, Stražaru izgleda kao Vukodlak, ali je zapravo lojalni Seljak.',
    shaman_desc: 'Mistični vidovnjak koji komunicira s duhovima. Svake druge noći, Šaman može pregledati jednog igrača i saznati njegovu pravu ulogu. Za razliku od Stražara, Šaman vidi kroz sve maske.',
    wraith_desc: 'Nemirni duh vezan za selo. Utvara ne može biti ubijena ni na koji način — ni od vukodlaka, vrača, vješanja, niti pogubljenja. Vječno luta, bdijući nad živima.',
    werewolf_desc: 'Žestoki grabežljivac gladan seljana. Svake noći može ubiti jednog igrača. Pobjeđuju ako nadmaše selo.',
    avenging_twin_desc: 'Blizanac vođen osvetom. Kada mu selo objesi brata, prihvaća tamu i pridružuje se vukovima.',
    vampire_desc: 'Mračno stvorenje noći. Budi se i ubija s vukovima svake noći, ali ostaje neotkriven od strane Stražara.',
    dire_wolf_desc: 'Zastrašujući alfa grabežljivac. Lovi s čoporom, zatim se svake druge noći budi sam da ušuti jednog igrača, sprječavajući ga da iskoristi svoju sposobnost sljedeće noći.',
    jester_desc: 'Smiješni šaljivdžija. Želi da ga selo objesi kako bi proglasio pobjedu.',
    puppet_master_desc: 'Mistični posmatrač. Transformiše se u ulogu prve osobe koju selo objesi.',
    gambler_desc: 'Lukavi rizičar koji se kladi na sudbinu. Prve noći, tajno bira za koji savez misli da će pobijediti. Ako pogodi, dijeli bodove sa pobjednicima. Inače se ponaša kao običan seljak.',

    rulebook_page_title: 'PRAVILA',
    rulebook_page_subtitle: 'Kako igrati Nightfall: Vukovi',
    rulebook_toc_title: 'SADRŽAJ',
    rulebook_page_label: 'STRANICA',
    on: 'OD',
    off: 'UGAŠENO',
    back: 'NAZAD',
    next_step_button: 'DALJE',

    rule_distribution_title: '1. Dodjela Uloga',
    rule_setup_title: '2. Postavljanje Igre',
    rule_alliances_title: '3. Savezi i Ciljevi',
    rule_night_title: '4. Noćna Faza',
    rule_day_title: '5. Dnevna Faza',
    rule_abilities_title: '6. Sposobnosti Likova',
    rule_scoring_title: '7. Bodovanje',

    rule_dist_p1: 'Proslijedite uređaj svakom igraču pojedinačno kako bi mogli vidjeti svoju ulogu u tajnosti.',
    rule_dist_p2: 'Igrači moraju potvrditi da su vidjeli i razumjeli svoju ulogu prije nego što uređaj predaju sljedećem igraču.',

    rule_setup_p1: 'Jedan igrač mora biti Narator. Narator ne učestvuje kao lik u igri i ne može biti ubijen ili izglasan.',
    rule_setup_p2: 'Narator kontrolira tok igre i slijedi upute iz aplikacije.',
    rule_setup_p3: 'Igrači nasumično dobijaju uloge koje pripadaju jednom od glavnih saveza: SELO ili VUKOVI.',
    rule_setup_p4: 'Neki igrači mogu dobiti posebne specijalne uloge sa dodatnim sposobnostima.',

    rule_all_p1: 'SELO: Pobjeđuje ako su svi Vukovi eliminisani.',
    rule_all_p2: 'VUKOVI: Pobjeđuju ako dostignu situaciju gdje je broj Vukova jednak ili veći od broja preostalih Seljana.',
    rule_all_p3: 'POSEBNI: Imaju svoje posebne uslove za pobjedu.',

    rule_night_p1: 'Svi igrači zatvaraju oči i ostaju tihi.',
    rule_night_p2: 'Narator budi specifične uloge jednu po jednu, slijedeći redoslijed prikazan u aplikaciji.',
    rule_night_p3: 'Kada je uloga budna, igrači koriste samo tihe geste. Za izvođenje sposobnosti, igrač pokazuje prstom na izabranog igrača.',
    rule_night_p4: 'Narator potvrđuje izbor i uputi igrača da se vrati na spavanje.',
    rule_night_p5: 'Nije dozvoljeno pričanje, pravljenje zvukova ili rasprava tokom Noćne Faze.',

    rule_day_p1: 'Narator objavljuje ishod Noći (ko je ubijen, ako je iko).',
    rule_day_p2: 'Eliminisani igrači moraju ostati tihi do kraja igre i ne mogu glasati.',
    rule_day_p3: 'Rasprava: Svi preživjeli igrači mogu slobodno diskutovati i optuživati druge.',
    rule_day_p4: 'Može se postaviti tajmer za raspravu. Tajmer služi samo kao podsjetnik Naratoru da završava dnevnu fazu.',
    rule_day_p5: 'Glasanje: Igrači mogu glasati da eliminišu osumnjičenog pokazujući prstom.',
    rule_day_p6: 'Igrač je obješen i eliminisan samo ako dobije više od polovine glasova svih živih igrača.',
    rule_day_p7: 'Glasanje se može preskočiti.',
    rule_day_p8: 'Ako nijedan igrač ne dobije apsolutnu većinu, ili u slučaju neriješenog, nijedan igrač nije eliminisan.',

    rule_ab_werewolf: 'VUKODLAK: Budi se noću sa ostalim Vukovima i zajedno biraju jednu žrtvu za ubistvo.',
    rule_ab_villager: 'SELJAK: Nema posebnu sposobnost. Oslanja se na raspravu, logiku i glasanje.',
    rule_ab_vampire: 'VAMPIR: Budi se sa Vukovima, ali kada ga Stražar pregleda, pojavljuje se kao Seljak. Može biti ubijena ako napadne Zaraženu.',
    rule_ab_doctor: 'DOKTOR: Svake noći bira jednog igrača koga će zaštititi od ubistva. Može zaštititi i sebe. Ne može zaštititi istog igrača dva uzastopna puta.',
    rule_ab_guard: 'STRAŽAR: Pregledava jednog igrača svake noći. Narator privatno prikazuje rezultat pregleda Stražaru. Rezultat: SELJANIN – Sve vrste Seljana, Vampiri i Lude. VUKODLAK – Vukodlaci, Pijanice i Osvetnički Blizanac.',
    rule_ab_plague_doctor: 'VRAČ: Može zaštititi jednog igrača noću, ali postoji mala šansa da ga i ubije. Može zaštititi i sebe. Ne može zaštititi istog igrača dva uzastopna puta.',
    rule_ab_twins: 'BLIZANCI: Ako je jedan Blizanac obješen tokom Dnevne Faze, drugi se odmah pretvara u Vuka. Ako je jedan ubijen tokom Noći, drugi ostaje Seljak.',
    rule_ab_avenging_twin: 'OSVETNIČKI BLIZANAC: Ako je njihov Blizanac obješen, transformišu se. Od naredne noći, bude se i djeluju sa Vukovima.',
    rule_ab_jester: 'LUDA: Pobjeđuje trenutno i sama ako je eliminisana glasanjem sela tokom Dnevne Faze.',
    rule_ab_drunk: 'PIJANICA: Nema posebnu sposobnost i ponaša se kao običan Seljak. Kada ga Stražar pregleda, identifikuje se kao Vuk.',
    rule_ab_knight: 'VITEZ: Seljak sa dva života, jedan zaštićen oklopom. Prvi život (Oklop): Ne može ga liječiti Doktor niti Vrač. Oklop može biti uništen napadom Vukova ili slučajnom smrću od Vrača. Drugi život: Može biti ubijen od strane Vukova ili Vrača, ali može biti spašen. Vješanje ga ubija bez obzira na živote.',
    rule_ab_puppet_master: 'LUTKAR: Započinje igru kao obični Seljanin. Kada se dogodi prvo vješanje, Lutkar preuzima ulogu obješenog igrača. Ako Luda bude obješena, Luda odmah pobjeđuje. Ako Kockar bude obješen, Lutkar nasljeđuje okladu.',
    rule_ab_executioner: 'DŽELAT: Osvetoljubivi seljak. Ako bude obješen od strane sela, može povesti jednog igrača sa sobom u grob.',
    rule_ab_infected: 'ZARAŽENA: Seljak koji nosi skrivenu bolest. Ako ga Doktor izliječi, Doktor se zarazi i umire. Ako ga vukovi ciljaju sa Vampirom, Vampir se zarazi i umire.',
    rule_ab_gambler: 'KOCKAR: Lukavi rizičar. Samo prve noći, tajno bira za koji savez misli da će pobijediti. Nakon klađenja, ponaša se kao običan Seljak. Ako pogodi, osvaja bonus bodove: +1 za Seljane, +2 za Vukove, +3 za Posebne.',
    rule_ab_shaman: 'ŠAMAN: Mistični vidovnjak koji komunicira s duhovima. Svake druge noći (2., 4., 6…), Šaman se budi posljednji i može pregledati jednog igrača. Za razliku od Stražara, Šaman vidi pravu ulogu. Šaman ne može pregledati samog sebe.',
    rule_ab_wraith: 'UTVARA: Nemirni duh vezan za selo. Utvara ne može biti ubijena ni na koji način — ni od vukodlaka, kuge, vješanja, niti pogubljenja. Vječno luta, bdijući nad živima.',
    rule_ab_dire_wolf: 'ZLI VUK: Zastrašujući alfa. Lovi s Vukovima svake noći. Svake druge noći Zli Vuk se budi sam da ušuti jednog igrača, koji sljedeće noći ne može iskoristiti svoju sposobnost.',

    rule_score_p1: 'Bodovi se dodjeljuju članovima pobjedničkog saveza na kraju igre.',
    rule_score_p2: 'Različite uloge daju različit broj bodova u zavisnosti od njihove težine.',
    rule_score_p3: 'Punu raspodjelu bodova možete pronaći u sekciji Uloge.',
    rule_score_p4: 'Posebni ne pripadaju savezu i imaju svoje posebne uslove za pobjedu.',
    rule_score_p5: 'Uživajte u misteriji i obmani. Sretno!',

    footer_text: 'NIGHTFALL PROJECT © 2025',
};
