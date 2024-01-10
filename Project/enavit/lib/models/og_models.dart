import 'dart:ffi';

class Approval {
  final String clubId;
  final Map<String, dynamic> dateTime;
  final String description;
  final String approvalId;
  final String eventName;
  final String location;
  final String fee;
  final List<String> organisers;
  final int likes;
  final Map<String, String> comments;
  final List<String> participants;
  final String eventImageURL;
  final int approved;

  //Add this line

  Approval(
      {required this.clubId,
      required this.dateTime,
      required this.description,
      required this.approvalId,
      required this.eventName,
      required this.location,
      required this.organisers,
      required this.comments,
      required this.participants,
      required this.likes,
      required this.fee,
      required this.eventImageURL,
      required this.approved,
      // Add this line
      });
}

class Club {
  final String clubId;
  final String clubName;
  final String bio;
  final String email;
  final List<String> events;
  final List<String> approvers;

  Club({
    required this.clubId,
    required this.clubName,
    required this.bio,
    required this.email,
    required this.events,
    required this.approvers,
  });
}

class Event {
  final String clubId;
  final Map<String, dynamic> dateTime;
  final String description;
  final String eventId;
  final String eventName;
  final String location;
  final String fee;
  final List<String> organisers;
  final int likes;
  final Map<String, String> comments;
  final List<String> participants;
  final String eventImageURL;
  final String extraInfo;

  //Add this line

  Event(
      {required this.clubId,
      required this.dateTime,
      required this.description,
      required this.eventId,
      required this.eventName,
      required this.location,
      required this.organisers,
      required this.comments,
      required this.participants,
      required this.likes,
      required this.fee,
      required this.eventImageURL,
      required this.extraInfo
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

class Users {
  final String email;
  final String name;
  final int role; // for participants and other roles
  final String phoneNo;
  final String regNo;
  final String userId;
  final List<String> events;
  final List<String> organizedEvents;
  final List<String> approvalEvents;
  final List<String> clubs;
  final String profileImageURL;

  Users({
    required this.email,
    required this.name,
    required this.role,
    required this.phoneNo,
    required this.regNo,
    required this.userId,
    required this.events,
    required this.organizedEvents,
    required this.approvalEvents,
    required this.clubs,
    required this.profileImageURL,
  });
}
