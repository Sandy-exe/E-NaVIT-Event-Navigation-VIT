import 'package:enavit/services/db_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SyncService {
  final dbHelper = DatabaseHelper();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> syncAndCheckAttendance(String eventId) async {
    try {
      // Get event data
      DocumentSnapshot eventSnapshot =
          await firestore.collection('Events').doc(eventId).get();
      if (!eventSnapshot.exists) {
        print("Event with ID $eventId not found.");
        return false;
      }

      List<dynamic> participantIds = eventSnapshot.get('participants');

      for (String participantId in participantIds) {
        final userRef = firestore.collection('app_users').doc(participantId);
        final userSnapshot = await userRef.get();

        if (!userSnapshot.exists) {
          print("User with ID $participantId not found in Firestore.");
          continue; // Skip to the next participant if user not found
        }

        Map<String, dynamic> userData = userSnapshot.data()!;
        String name = userData['name'];
        String regNo = userData['reg_no'];

        // Sync data locally
        var result = await dbHelper.getAttendee(eventId, participantId);

        // Insert new attendee if not found, or check attendance if they have attended
        if (result == null) {
          await dbHelper.insertAttendee(eventId, participantId, regNo, name);
        } else if (result['attended'] == 1) {
          // Check if user has already attended
          if (eventSnapshot.get('attendancePresent').contains(participantId)) {
            print("User $participantId has already updated.");
            continue; // Skip to the next participant
          }

          // Update attended events for the current user
          List<String> attendedEvents =
              List<String>.from(userData['attendedEvents']);
          attendedEvents.add(eventId);
          await userRef.update({"attendedEvents": attendedEvents});

          // Update the event's attendance record
          List<String> attendancePresent =
              List<String>.from(eventSnapshot.get('attendancePresent'));
          attendancePresent.add(participantId);
          await eventSnapshot.reference
              .update({"attendancePresent": attendancePresent});
        }
      }

      print("Data sync completed for event ID: $eventId");
      return true;
    } catch (e) {
      print("Error syncing data from Firestore: $e");
      return false;
    }
  }
}
