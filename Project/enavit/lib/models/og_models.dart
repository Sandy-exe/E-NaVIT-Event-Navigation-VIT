

class Approval {
  final int userId;
  final int clubId;
  final int approvalId;
  final int status;// pending, approved, rejected
  final String message;
  Approval({
    required this.userId,
    required this.clubId,
    required this.approvalId,
    required this.status,
    required this.message,
  });
}

class Club {
  final int clubId;
  final String clubName;
  final String description;
  final String email;
  final List<int> events;
  final List<int> approvers;

  Club({
    required this.clubId,
    required this.clubName,
    required this.description,
    required this.email,
    required this.events,
    required this.approvers,
  });
}

class Event {
  final int clubId;
  final DateTime date;
  final String description;
  final int eventId;
  final String eventName;
  final String eventTime;
  final String location;
  final List<int> organisers;
  final DateTime time;
  final int likes;
  final List<int> comments;
  final List<int> partcipants;// Add this line

  Event({
    required this.clubId,
    required this.date,
    required this.description,
    required this.eventId,
    required this.eventName,
    required this.eventTime,
    required this.location,
    required this.organisers,
    required this.time,
    required this.comments,
    required this.partcipants, 
    required this.likes,
    // Add this line
  });
}

class Comments {
  final String comment;
  final int commentId;
  final String eventId;
  final int userId;

  Comments({
    required this.comment,
    required this.commentId,
    required this.eventId,
    required this.userId,
  });
}

class ParticipantRequest {
  final int userId;
  final int eventId;
  ParticipantRequest({
    required this.userId,
    required this.eventId,
  });
}

class User {
  final String email;
  final String name;
  final int role;// for participants and other roles
  final String phoneNo;
  final String regNo;
  final int userId;
  final List<int> events;
  final List<int> organizedEvents;
  final List<int> clubs;

  User({
    required this.email,
    required this.name,
    required this.role,
    required this.phoneNo,
    required this.regNo,
    required this.userId,
    required this.events,
    required this.organizedEvents,
    required this.clubs,
  });
}
