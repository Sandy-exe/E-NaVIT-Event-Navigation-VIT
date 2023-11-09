class Event {
  final int id;
  final int clubid;
  final String name;
  final String description;
  final String fee;
  final String venue;
  final DateTime date;
  final String imagePath;

  Event({
  required this.id,
  required this.clubid,
  required this.name,
  required this.description,
  required this.fee,
  required this.venue,
  required this.date,
  required this.imagePath,
  });
}