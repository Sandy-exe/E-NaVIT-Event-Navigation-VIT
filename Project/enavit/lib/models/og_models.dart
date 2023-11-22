class Approval {
  final String userId;
  final String clubId;
  final String approvalId;
  final String status;

  Approval({
    required this.userId,
    required this.clubId,
    required this.approvalId,
    required this.status,
  });
}

class Club {
  final String clubId;
  final String clubName;
  final String description;
  final String email;

  Club({
    required this.clubId,
    required this.clubName,
    required this.description,
    required this.email,
  });
}

class Event {
  final String club;
  final String date;
  final String description;
  final String eventId;
  final String eventName;
  final String eventTime;
  final String location;
  final String organiser;
  final String time;

  Event({
    required this.club,
    required this.date,
    required this.description,
    required this.eventId,
    required this.eventName,
    required this.eventTime,
    required this.location,
    required this.organiser,
    required this.time,
  });
}

class LikesComments {
  final String comment;
  final String commentId;
  final String eventId;
  final String userId;

  LikesComments({
    required this.comment,
    required this.commentId,
    required this.eventId,
    required this.userId,
  });
}

class Participant {
  final String userId;
  final String eventId;

  Participant({
    required this.userId,
    required this.eventId,
  });
}

class User {
  final String email;
  final String name;
  final bool organiser;
  final int phoneNo;
  final String regNo;
  final String userId;

  User({
    required this.email,
    required this.name,
    required this.organiser,
    required this.phoneNo,
    required this.regNo,
    required this.userId,
  });
}
