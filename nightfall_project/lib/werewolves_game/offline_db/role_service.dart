class WerewolfRole {
  final int id;
  final String name;
  final int points;
  final int allianceId;
  final String description;
  final String imagePath;

  WerewolfRole({
    required this.id,
    required this.name,
    required this.points,
    required this.allianceId,
    required this.description,
    required this.imagePath,
  });
}

class WerewolfRoleService {
  static final List<WerewolfRole> _roles = [
    WerewolfRole(
      id: 1,
      name: 'Villager',
      points: 1,
      allianceId: 1, // Villagers
      description: 'A simple townsperson trying to survive the night.',
      imagePath: 'assets/images/werewolves/Villager.png',
    ),
    WerewolfRole(
      id: 2,
      name: 'Werewolf',
      points: 2,
      allianceId: 2, // Werewolves
      description:
          'A fierce predator hungry for villagers. Each night, they can kill one player. Wins if they outnumber the village.',
      imagePath: 'assets/images/werewolves/Werewolf.png',
    ),
    WerewolfRole(
      id: 3,
      name: 'Doctor',
      points: 1,
      allianceId: 1, // Villagers
      description:
          'A dedicated healer. Each night, she can save one person from being attacked that night.',
      imagePath: 'assets/images/werewolves/Doctor.png',
    ),
    WerewolfRole(
      id: 4,
      name: 'Guard',
      points: 1,
      allianceId: 1, // Villagers
      description:
          'A vigilant protector. Each night, he can inspect one player.',
      imagePath: 'assets/images/werewolves/Guard.png',
    ),
    WerewolfRole(
      id: 5,
      name: 'Plague Doctor',
      points: 1,
      allianceId: 1, // Villagers
      description:
          'A mysterious healer. Each night, he can save one player but also has a small chance to kill him.',
      imagePath: 'assets/images/werewolves/Plague Doctor.png',
    ),
    WerewolfRole(
      id: 6,
      name: 'Twins',
      points: 1,
      allianceId: 1, // Villagers
      description:
          'Two souls bound together. If one is hanged by the village, the other turns into a werewolf. if one is killed by a werewolf, the other remains a villager.',
      imagePath: 'assets/images/werewolves/Twins.png',
    ),
    WerewolfRole(
      id: 7,
      name: 'Avenging Twin',
      points: 3,
      allianceId: 2, // Werewolves
      description:
          'A twin fueled by vengeance. When their sibling is hanged by the village, they embrace the darkness and join the werewolves to hunt down those who killed their loved one.',
      imagePath: 'assets/images/werewolves/Avenging Twin.png',
    ),
    WerewolfRole(
      id: 8,
      name: 'Vampire',
      points: 2,
      allianceId: 2, // Werewolves
      description:
          'A dark creature of the night. Awakens and kills with the werewolves each night, but remains undetected by the Guard.',
      imagePath: 'assets/images/werewolves/Vampire.png',
    ),
    WerewolfRole(
      id: 9,
      name: 'Jester',
      points: 3,
      allianceId: 3, // Jester
      description:
          'A silly trickster. Wants to be hanged by the village to claim victory.',
      imagePath: 'assets/images/werewolves/Jester.png',
    ),
  ];

  List<WerewolfRole> getRoles() => _roles;

  WerewolfRole? getRoleById(int id) {
    try {
      return _roles.firstWhere((role) => role.id == id);
    } catch (_) {
      return null;
    }
  }

  List<WerewolfRole> getRolesByAlliance(int allianceId) {
    return _roles.where((role) => role.allianceId == allianceId).toList();
  }
}
