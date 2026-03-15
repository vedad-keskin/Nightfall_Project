import type { TranslationKey } from '../../shared/language/translations';

export interface RuleSection {
    id: string;
    title: string;
    titleKey: TranslationKey;
    paragraphs: string[];
    paragraphKeys: TranslationKey[];
}

export const RULES_SECTIONS: RuleSection[] = [
    {
        id: 'role-distribution',
        title: '1. Role Distribution',
        titleKey: 'rule_distribution_title',
        paragraphs: [
            'Pass the device to each player individually so they can view their role in secret.',
            'Players must confirm they have seen and understood their role before passing the device to the next player.',
        ],
        paragraphKeys: ['rule_dist_p1', 'rule_dist_p2'],
    },
    {
        id: 'setup',
        title: '2. Setup',
        titleKey: 'rule_setup_title',
        paragraphs: [
            'One player needs to be the Narrator. The Narrator does not participate as a character and cannot be killed or voted out.',
            'The Narrator controls the flow of the game and follows instructions provided by the app.',
            'Players are randomly assigned roles belonging to one of the main alliances: THE VILLAGE or THE WEREWOLVES.',
            'Some players may receive unique special roles with additional abilities.',
        ],
        paragraphKeys: [
            'rule_setup_p1',
            'rule_setup_p2',
            'rule_setup_p3',
            'rule_setup_p4',
        ],
    },
    {
        id: 'alliances',
        title: '3. Alliances and Goals',
        titleKey: 'rule_alliances_title',
        paragraphs: [
            'THE VILLAGE: Wins if all Werewolves are eliminated.',
            'THE WEREWOLVES: Win if they reach a point where the number of Werewolves is equal to or greater than the number of remaining Villagers.',
            'THE SPECIALS: They have their own special winning conditions.',
        ],
        paragraphKeys: ['rule_all_p1', 'rule_all_p2', 'rule_all_p3'],
    },
    {
        id: 'night-phase',
        title: '4. The Night Phase',
        titleKey: 'rule_night_title',
        paragraphs: [
            'All players close their eyes and remain silent.',
            'The Narrator wakes specific roles one by one, following the order shown in the app.',
            'When a role is awake, players use silent gestures only. To execute their ability, they point their finger at the chosen player.',
            'The Narrator acknowledges the choice and instructs the role to return to sleep.',
            'No speaking, sounds, or discussion are allowed during the Night Phase.',
        ],
        paragraphKeys: [
            'rule_night_p1',
            'rule_night_p2',
            'rule_night_p3',
            'rule_night_p4',
            'rule_night_p5',
        ],
    },
    {
        id: 'day-phase',
        title: '5. The Day Phase',
        titleKey: 'rule_day_title',
        paragraphs: [
            'The Narrator announces the outcome of the Night (who was killed, if anyone).',
            'Eliminated players must remain silent for the rest of the game and may not vote.',
            'Discussion: All surviving players may freely discuss and accuse others.',
            'A discussion timer may be set when creating the game. The timer serves only as a reminder for the Narrator to move the game forward.',
            'Voting: Players may vote to eliminate a suspect by pointing at them.',
            'A player is hanged and eliminated only if they receive more than half of the votes from all living players.',
            'Voting may be skipped.',
            'If no player receives a strict majority, or in case of a tie, no player is eliminated.',
        ],
        paragraphKeys: [
            'rule_day_p1',
            'rule_day_p2',
            'rule_day_p3',
            'rule_day_p4',
            'rule_day_p5',
            'rule_day_p6',
            'rule_day_p7',
            'rule_day_p8',
        ],
    },
    {
        id: 'abilities',
        title: '6. Character Abilities',
        titleKey: 'rule_abilities_title',
        paragraphs: [
            'WEREWOLF: Awakens at night with other Werewolves and collectively chooses one victim to kill.',
            'VILLAGER: Has no special ability. Relies on discussion, logic, and voting.',
            'VAMPIRE: Awakens with the Werewolves but appears as a Villager when inspected. Can be killed when targeting the Infected.',
            'DOCTOR: Chooses one player each night to protect from being killed. May protect themselves. Cannot protect the same player on two consecutive nights.',
            'GUARD: Inspects one player each night. The Narrator privately shows the inspection result on their device to the Guard. Inspection Result: VILLAGER – All types of Villagers, Vampires, and Jesters. WEREWOLF – Werewolves, Drunks, and the Avenging Twin.',
            'PLAGUE DOCTOR: Can protect one player at night, but there is a small chance the target dies instead. May protect themselves. Cannot protect the same player on two consecutive nights.',
            'TWINS: If one Twin is hanged during the Day Phase, the other immediately becomes a Werewolf. If one Twin is killed during the Night Phase, the other remains a Villager.',
            'AVENGING TWIN: If their Twin is hanged, they transform into an Avenging Twin. From the next night onward, they awaken and act with the Werewolves.',
            'JESTER: Wins instantly and alone if eliminated by Village vote during the Day Phase.',
            'DRUNK: Has no special ability and behaves as a normal Villager. When inspected by the Guard, the Drunk is suspicious and appears as a Werewolf.',
            'KNIGHT: A Villager with two lives, one protected by armor. First life (Armor): Cannot be healed by the Doctor or Plague Doctor. The armor can be destroyed by a Werewolf attack or a Plague Doctor accidental kill. If both attacks happen on the same night, the Knight dies immediately. Second life: Can be killed by Werewolves or a Plague Doctor accidental kill. The second life can be saved by either the Doctor or the Plague Doctor. Hanging kills him immediately.',
            'PUPPET MASTER: Starts the game as a normal Villager. When the first hanging of the game occurs, the Puppet Master transforms into the role of the hanged player. The hanged player is eliminated normally. If the Jester is hanged, the Jester wins immediately and no Puppet Master transformation occurs. If the Gambler is hanged, the Puppet Master inherits the bet.',
            'EXECUTIONER: A vengeful villager. If hanged by the village, he can take one player with him to the grave.',
            'INFECTED: A villager carrying a hidden sickness. If the Doctor heals them, the Doctor gets infected and dies. If targeted by the Werewolves with a Vampire, the Vampire gets infected and dies too.',
            'GAMBLER: A cunning risk-taker. On the first night only, the Gambler secretly chooses which alliance they believe will win. After placing their bet, they behave as a normal Villager. If correct, they earn bonus points: +1 for Village, +2 for Werewolves, +3 for Specials.',
            'SHAMAN: A mystical seer who communes with the spirits. Every second night (2nd, 4th, 6th…), the Shaman wakes up last and can inspect one player. Unlike the Guard, the Shaman sees the player\'s true role. The Shaman cannot inspect himself.',
            'WRAITH: A restless spirit bound to the village. The Wraith cannot be killed by any means — not by werewolves, plague, hanging, or execution. It lingers eternally, watching over the living.',
            'DIRE WOLF: A terrifying alpha predator aligned with the Werewolves. Wakes up with the pack and participates in the kill. After the wolves sleep, the Dire Wolf wakes alone every other night (1st, 3rd, 5th...) to silence one player. The silenced player cannot use their active ability the following night. Silence only affects roles that wake up at night: Doctor, Guard, Plague Doctor, and Shaman. Passive abilities (Knight armor, Wraith immortality, Jester, Executioner) are not affected. Cannot silence wolves, himself, or the same player as last time. Appears as a Werewolf when inspected by the Guard.',
        ],
        paragraphKeys: [
            'rule_ab_werewolf',
            'rule_ab_villager',
            'rule_ab_vampire',
            'rule_ab_doctor',
            'rule_ab_guard',
            'rule_ab_plague_doctor',
            'rule_ab_twins',
            'rule_ab_avenging_twin',
            'rule_ab_jester',
            'rule_ab_drunk',
            'rule_ab_knight',
            'rule_ab_puppet_master',
            'rule_ab_executioner',
            'rule_ab_infected',
            'rule_ab_gambler',
            'rule_ab_shaman',
            'rule_ab_wraith',
            'rule_ab_dire_wolf',
        ],
    },
    {
        id: 'scoring',
        title: '7. Scoring',
        titleKey: 'rule_scoring_title',
        paragraphs: [
            'Points are awarded to members of the winning alliance at the end of the game.',
            'Different roles grant different amounts of points depending on their difficulty.',
            'Full point distributions can be found in the Roles section of the game.',
            'Special roles do not belong to an alliance and instead have their own winning conditions.',
            'Enjoy the mystery and deception. Good luck!',
        ],
        paragraphKeys: [
            'rule_score_p1',
            'rule_score_p2',
            'rule_score_p3',
            'rule_score_p4',
            'rule_score_p5',
        ],
    },
];
