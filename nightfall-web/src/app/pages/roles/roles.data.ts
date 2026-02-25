export interface Role {
  id: string;
  name: string;
  description: string;
  alliance: 'village' | 'werewolves' | 'specials';
  image: string;
}

export interface Alliance {
  id: 'village' | 'werewolves' | 'specials';
  name: string;
  description: string;
}

export const ALLIANCES: Alliance[] = [
  {
    id: 'village',
    name: 'The Village',
    description:
      'The peaceful inhabitants of the village. Their goal is to find and eliminate all werewolves.',
  },
  {
    id: 'werewolves',
    name: 'The Werewolves',
    description:
      'The predators of the night. Their goal is to outnumber the villagers to take over the town.',
  },
  {
    id: 'specials',
    name: 'Specials',
    description:
      'Independent roles with unique win conditions and special abilities.',
  },
];

export const ROLES: Role[] = [
  // ── Village ──
  {
    id: 'villager',
    name: 'Villager',
    description: 'A simple townsperson trying to survive the night.',
    alliance: 'village',
    image: 'images/werewolves/Villager.png',
  },
  {
    id: 'doctor',
    name: 'Doctor',
    description:
      'A dedicated healer. Each night, she can save one person from being attacked that night.',
    alliance: 'village',
    image: 'images/werewolves/Doctor.png',
  },
  {
    id: 'guard',
    name: 'Guard',
    description:
      'A vigilant protector. Each night, he can inspect one player.',
    alliance: 'village',
    image: 'images/werewolves/Guard.png',
  },
  {
    id: 'plague_doctor',
    name: 'Plague Doctor',
    description:
      'A mysterious healer. Each night, he can save one player but also has a small chance to kill him.',
    alliance: 'village',
    image: 'images/werewolves/Plague Doctor.png',
  },
  {
    id: 'twins',
    name: 'Twins',
    description:
      'Two souls bound together. If one is hanged by the village, the other becomes an Avenging Twin. If one is killed by a werewolf, the other remains a villager.',
    alliance: 'village',
    image: 'images/werewolves/Twins.png',
  },
  {
    id: 'knight',
    name: 'Knight',
    description:
      'A brave warrior. He has armor that protects him from the first lethal attack. He only dies if attacked a second time.',
    alliance: 'village',
    image: 'images/werewolves/Knight.png',
  },
  {
    id: 'puppet_master',
    name: 'Puppet Master',
    description:
      'A mysterious observer. Transforms into the role of the first person who gets hanged by the village.',
    alliance: 'village',
    image: 'images/werewolves/Puppet Master.png',
  },
  {
    id: 'executioner',
    name: 'Executioner',
    description:
      'A vengeful villager. If hanged by the village, he can take one player with him to the grave.',
    alliance: 'village',
    image: 'images/werewolves/Executioner.png',
  },
  {
    id: 'infected',
    name: 'Infected',
    description:
      'A villager carrying a hidden sickness. If the Doctor heals them, the Doctor gets infected and dies. If the werewolves target them at night while they have a vampire in their team, the vampire gets infected and dies.',
    alliance: 'village',
    image: 'images/werewolves/Infected.png',
  },
  {
    id: 'gambler',
    name: 'Gambler',
    description:
      'A cunning risk-taker who bets on fate. On the first night, they secretly choose which alliance they believe will win. If correct, they share in the victory points. Behaves as a normal villager otherwise.',
    alliance: 'village',
    image: 'images/werewolves/Gambler.png',
  },
  {
    id: 'drunk',
    name: 'Drunk',
    description:
      'A confused drinker. Due to intoxication, he appears as a Werewolf to the Guard, but is actually a loyal Villager.',
    alliance: 'village',
    image: 'images/werewolves/Drunk.png',
  },
  {
    id: 'shaman',
    name: 'Shaman',
    description:
      'A mystical seer who communes with the spirits. Every second night, the Shaman can inspect one player and learn their true role. Unlike the Guard, the Shaman sees through all disguises.',
    alliance: 'village',
    image: 'images/werewolves/Shaman.png',
  },
  // ── Werewolves ──
  {
    id: 'werewolf',
    name: 'Werewolf',
    description:
      'A fierce predator hungry for villagers. Each night, they can kill one player. Wins if they outnumber the village.',
    alliance: 'werewolves',
    image: 'images/werewolves/Werewolf.png',
  },
  {
    id: 'avenging_twin',
    name: 'Avenging Twin',
    description:
      'A twin fueled by vengeance. When their sibling is hanged by the village, they embrace the darkness and join the werewolves.',
    alliance: 'werewolves',
    image: 'images/werewolves/Avenging Twin.png',
  },
  {
    id: 'vampire',
    name: 'Vampire',
    description:
      'A dark creature of the night. Awakens and kills with the werewolves each night, but remains undetected by the Guard.',
    alliance: 'werewolves',
    image: 'images/werewolves/Vampire.png',
  },
  // ── Specials ──
  {
    id: 'jester',
    name: 'Jester',
    description:
      'A silly trickster. Wants to be hanged by the village to claim victory.',
    alliance: 'specials',
    image: 'images/werewolves/Jester.png',
  },
];
