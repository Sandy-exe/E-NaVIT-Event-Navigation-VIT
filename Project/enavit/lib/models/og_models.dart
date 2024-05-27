
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

  Approval({
    required this.clubId,
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
  final List<String> followers;

  Club({
    required this.clubId,
    required this.clubName,
    required this.bio,
    required this.email,
    required this.events,
    required this.approvers,

    required this.followers,
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
  final String discussionPoints;
  final String eventType;
  final String eventCategory;
  final String fdpProposedBy;
  final String schoolCentre;
  final String coordinator1;
  final String coordinator2;
  final String coordinator3;
  final String attendancePresent;
  final Map<String,Map<String,String>> issues;
  final String expense;
  final String expectedRevenue;
  final String budget;
  final String revenue;

  //Add this line

  Event({
    required this.clubId,
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
    required this.discussionPoints,
    required this.eventType,
    required this.eventCategory,
    required this.fdpProposedBy,
    required this.schoolCentre,
    required this.coordinator1,
    required this.coordinator2,
    required this.coordinator3,
    required this.attendancePresent,
    required this.issues,
    required this.expense,
    required this.revenue,
    required this.budget,
    required this.expectedRevenue,

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
  final String fcmToken;
  final List<String> favorites;
  final List<String> followingClubs;
  final List<String> notifications;
  final List<String> clubIds;


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
    required this.fcmToken,
    required this.favorites,
    required this.followingClubs,
    required this.notifications,
    required this.clubIds,
  });
}
