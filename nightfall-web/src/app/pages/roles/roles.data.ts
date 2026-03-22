import type { TranslationKey } from '../../shared/language/translations';

export interface Role {
    id: string;
    numericId: number; // Matches Flutter roleId
    name: string;
    nameKey: TranslationKey;
    description: string;
    descriptionKey: TranslationKey;
    alliance: 'village' | 'werewolves' | 'specials';
    image: string;
    points: number; // 0 means variable/special
    pointsNote?: string; // optional note for special point rules
    pointsNoteKey?: TranslationKey;
}

export interface Alliance {
    id: 'village' | 'werewolves' | 'specials';
    numericId: number; // Matches Flutter allianceId
    name: string;
    nameKey: TranslationKey;
    description: string;
    descriptionKey: TranslationKey;
}

export const ALLIANCES: Alliance[] = [
    {
        id: 'village',
        numericId: 1,
        name: 'The Village',
        nameKey: 'villagers_alliance_name',
        description:
            'The peaceful inhabitants of the village. Their goal is to find and eliminate all werewolves.',
        descriptionKey: 'villagers_alliance_desc',
    },
    {
        id: 'werewolves',
        numericId: 2,
        name: 'The Werewolves',
        nameKey: 'werewolves_alliance_name',
        description:
            'The predators of the night. Their goal is to outnumber the villagers to take over the town.',
        descriptionKey: 'werewolves_alliance_desc',
    },
    {
        id: 'specials',
        numericId: 3,
        name: 'Specials',
        nameKey: 'specials_alliance_name',
        description:
            'Independent roles with unique win conditions and special abilities.',
        descriptionKey: 'specials_alliance_desc',
    },
];

export const ROLES: Role[] = [
    // ── Village (allianceId 1) ──
    {
        id: 'villager',
        numericId: 1,
        name: 'Villager',
        nameKey: 'villager_name',
        description: 'A simple townsperson trying to survive the night.',
        descriptionKey: 'villager_desc',
        alliance: 'village',
        image: 'images/werewolves/Villager.png',
        points: 1,
    },
    {
        id: 'doctor',
        numericId: 3,
        name: 'Doctor',
        nameKey: 'doctor_name',
        description:
            'A dedicated healer. Each night, she can save one person from being attacked that night.',
        descriptionKey: 'doctor_desc',
        alliance: 'village',
        image: 'images/werewolves/Doctor.png',
        points: 1,
    },
    {
        id: 'guard',
        numericId: 4,
        name: 'Guard',
        nameKey: 'guard_name',
        description:
            'A vigilant protector. Each night, he can inspect one player.',
        descriptionKey: 'guard_desc',
        alliance: 'village',
        image: 'images/werewolves/Guard.png',
        points: 1,
    },
    {
        id: 'plague_doctor',
        numericId: 5,
        name: 'Plague Doctor',
        nameKey: 'plague_doctor_name',
        description:
            'A mysterious healer. Each night, he can save one player but also has a small chance to kill him.',
        descriptionKey: 'plague_doctor_desc',
        alliance: 'village',
        image: 'images/werewolves/Plague Doctor.png',
        points: 1,
    },
    {
        id: 'twins',
        numericId: 6,
        name: 'Twins',
        nameKey: 'twins_name',
        description:
            'Two souls bound together. If one is hanged by the village, the other becomes an Avenging Twin. If one is killed by a werewolf, the other remains a villager.',
        descriptionKey: 'twins_desc',
        alliance: 'village',
        image: 'images/werewolves/Twins.png',
        points: 1,
    },
    {
        id: 'knight',
        numericId: 11,
        name: 'Knight',
        nameKey: 'knight_name',
        description:
            'A brave warrior. He has armor that protects him from the first lethal attack. He only dies if attacked a second time.',
        descriptionKey: 'knight_desc',
        alliance: 'village',
        image: 'images/werewolves/Knight.png',
        points: 1,
    },
    {
        id: 'executioner',
        numericId: 13,
        name: 'Executioner',
        nameKey: 'executioner_name',
        description:
            'A vengeful villager. If hanged by the village, he can take one player with him to the grave.',
        descriptionKey: 'executioner_desc',
        alliance: 'village',
        image: 'images/werewolves/Executioner.png',
        points: 1,
    },
    {
        id: 'infected',
        numericId: 14,
        name: 'Infected',
        nameKey: 'infected_name',
        description:
            'A villager carrying a hidden sickness. If the Doctor heals them, the Doctor gets infected and dies. If the werewolves target them at night while they have a vampire in their team, the vampire gets infected and dies.',
        descriptionKey: 'infected_desc',
        alliance: 'village',
        image: 'images/werewolves/Infected.png',
        points: 1,
    },
    {
        id: 'drunk',
        numericId: 10,
        name: 'Drunk',
        nameKey: 'drunk_name',
        description:
            'A confused drinker. Due to intoxication, he appears as a Werewolf to the Guard, but is actually a loyal Villager.',
        descriptionKey: 'drunk_desc',
        alliance: 'village',
        image: 'images/werewolves/Drunk.png',
        points: 1,
    },
    {
        id: 'shaman',
        numericId: 16,
        name: 'Shaman',
        nameKey: 'shaman_name',
        description:
            'A mystical seer who communes with the spirits. Every second night, the Shaman can inspect one player and learn their true role. Unlike the Guard, the Shaman sees through all disguises.',
        descriptionKey: 'shaman_desc',
        alliance: 'village',
        image: 'images/werewolves/Shaman.png',
        points: 1,
    },
    {
        id: 'wraith',
        numericId: 17,
        name: 'Wraith',
        nameKey: 'wraith_name',
        description:
            'A restless spirit bound to the village. The Wraith cannot be killed by any means — not by werewolves, plague, hanging, or execution. It lingers eternally, watching over the living.',
        descriptionKey: 'wraith_desc',
        alliance: 'village',
        image: 'images/werewolves/Wraith.png',
        points: 1,
    },
    // ── Werewolves (allianceId 2) ──
    {
        id: 'werewolf',
        numericId: 2,
        name: 'Werewolf',
        nameKey: 'werewolf_name',
        description:
            'A fierce predator hungry for villagers. Each night, they can kill one player. Wins if they outnumber the village.',
        descriptionKey: 'werewolf_desc',
        alliance: 'werewolves',
        image: 'images/werewolves/Werewolf.png',
        points: 2,
    },
    {
        id: 'avenging_twin',
        numericId: 7,
        name: 'Avenging Twin',
        nameKey: 'avenging_twin_name',
        description:
            'A twin fueled by vengeance. When their sibling is hanged by the village, they embrace the darkness and join the werewolves.',
        descriptionKey: 'avenging_twin_desc',
        alliance: 'werewolves',
        image: 'images/werewolves/Avenging Twin.png',
        points: 3,
    },
    {
        id: 'vampire',
        numericId: 8,
        name: 'Vampire',
        nameKey: 'vampire_name',
        description:
            'A dark creature of the night. Awakens and kills with the werewolves each night, but remains undetected by the Guard.',
        descriptionKey: 'vampire_desc',
        alliance: 'werewolves',
        image: 'images/werewolves/Vampire.png',
        points: 2,
    },
    {
        id: 'dire_wolf',
        numericId: 18,
        name: 'Dire Wolf',
        nameKey: 'dire_wolf_name',
        description:
            'A terrifying alpha predator. Hunts with the pack, then wakes alone every other night to silence one player, preventing them from using their ability the following night.',
        descriptionKey: 'dire_wolf_desc',
        alliance: 'werewolves',
        image: 'images/werewolves/Dire Wolf.png',
        points: 2,
    },
    // ── Specials (allianceId 3) ──
    {
        id: 'jester',
        numericId: 9,
        name: 'Jester',
        nameKey: 'jester_name',
        description:
            'A silly trickster. Wants to be hanged by the village to claim victory.',
        descriptionKey: 'jester_desc',
        alliance: 'specials',
        image: 'images/werewolves/Jester.png',
        points: 3,
    },
    {
        id: 'puppet_master',
        numericId: 12,
        name: 'Puppet Master',
        nameKey: 'puppet_master_name',
        description:
            'A mysterious observer. Transforms into the role of the first person who gets hanged by the village.',
        descriptionKey: 'puppet_master_desc',
        alliance: 'specials',
        image: 'images/werewolves/Puppet Master.png',
        points: 0,
        pointsNote: 'Inherits points from transformed role',
        pointsNoteKey: 'puppet_master_points_note',
    },
    {
        id: 'gambler',
        numericId: 15,
        name: 'Gambler',
        nameKey: 'gambler_name',
        description:
            'A cunning risk-taker who bets on fate. On the first night, they secretly choose which alliance they believe will win. If correct, they share in the victory points. Behaves as a normal villager otherwise.',
        descriptionKey: 'gambler_desc',
        alliance: 'specials',
        image: 'images/werewolves/Gambler.png',
        points: 0,
        pointsNote: '+1 Village|+2 Werewolves|+3 Specials',
        pointsNoteKey: 'gambler_points_note',
    },
];

// ── Lookup helpers (used by live page to resolve Firebase IDs) ──

const _roleByNumericId = new Map<number, Role>(
    ROLES.map((r) => [r.numericId, r]),
);

const _allianceByNumericId = new Map<number, Alliance>(
    ALLIANCES.map((a) => [a.numericId, a]),
);

export function getRoleByNumericId(id: number): Role | undefined {
    return _roleByNumericId.get(id);
}

export function getAllianceByNumericId(id: number): Alliance | undefined {
    return _allianceByNumericId.get(id);
}
