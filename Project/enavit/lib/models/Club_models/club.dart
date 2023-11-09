class Club {
  final int id;
  final String name;
  final String description;
  final List<Member> members;
  final List<int> eventIds;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.eventIds,
  });
}

class Member {
  final int id;
  final String name;
  final String email;

  Member({
    required this.id,
    required this.name,
    required this.email,
  });
}
