import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit_main/models/og_models.dart';

class LeaderBoard {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Event>> getRankingEvents() async {
    try {
      // Fetch data from the "Events" collection and sort by "revenue"
      QuerySnapshot querySnapshot = await _firestore.collection('Events').get();

      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      // Convert revenue to double and sort

      // Convert the documents to a list of Event objects directly
      return docs.map((doc) {
        Map<String, dynamic> eventData = doc.data() as Map<String, dynamic>;

        return Event(
          clubId: eventData['clubId'],
          dateTime: eventData['dateTime'],
          description: eventData['description'],
          eventId: eventData['eventId'],
          eventName: eventData['eventName'],
          location: eventData['location'],
          fee: eventData['fee'],
          organisers: List<String>.from(eventData['organisers']),
          comments: Map<String, String>.from(eventData['comments']),
          participants: List<String>.from(eventData['participants']),
          likes: eventData['likes'],
          eventImageURL: eventData['eventImageURL'] ?? "null",
          discussionPoints: eventData['discussionPoints'] ?? "old doc",
          eventType: eventData['eventType'] ?? "old doc",
          eventCategory: eventData['eventCategory'] ?? "old doc",
          fdpProposedBy: eventData['fdpProposedBy'] ?? "old doc",
          schoolCentre: eventData['schoolCentre'] ?? "old doc",
          coordinator1: eventData['coordinator1'] ?? "old doc",
          coordinator2: eventData['coordinator2'] ?? "old doc",
          coordinator3: eventData['coordinator3'] ?? "old doc",
          expense: eventData['expense'] ?? [],
          revenue: eventData['revenue'] ?? "0",
          budget: eventData['budget'] ?? "0",
          attendancePresent: eventData['attendancePresent'] ?? [],
          issues: Map<String, Map<String, String>>.from(eventData['issues']),
          expectedRevenue: eventData['expectedRevenue'] ?? "0",
        );
      }).toList();
    } catch (e) {
      print("Error fetching Events data: $e");
      return [];
    }
  }

  Future<List<Club>> getRankingClubs() async {
    try {
      // Fetch data from the "Clubs" collection and sort by "revenue"
      QuerySnapshot querySnapshot = await _firestore.collection('Clubs').get();

      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      // Convert revenue to double and sort

      // Convert the documents to a list of Club objects directly
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> clubData = doc.data() as Map<String, dynamic>;

        return Club(
          clubId: clubData['clubId'],
          clubName: clubData['clubName'],
          bio: clubData['bio'],
          email: clubData['email'],
          events: List<String>.from(clubData['events']),
          approvers: List<String>.from(clubData['approvers']),
          followers: List<String>.from(clubData['followers']),
          posts: List<String>.from(clubData['posts']),
          revenue: clubData['revenue'],
          expense: clubData['expense'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching Clubs data: $e");
      return [];
    }
  }
}
