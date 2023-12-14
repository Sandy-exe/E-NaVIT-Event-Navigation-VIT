import 'package:enavit/components/flutter_flow_theme.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';

class ParticipantTile extends StatelessWidget {
  final Users user;
  const ParticipantTile({super.key, required this.user});

  void updateUserRole (String uid,context) {
    print(uid);
        Services service = Services();

        Map<String, dynamic> newinfo = {
          if (user.role == 1) 'role': 2 else 'role': 1,
        };

        print(newinfo);

        service.updateUser(uid, newinfo);
        
        Navigator.pop(context);
        showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Approve Status"),
        content: Text("User Role Changed"),
      ),
    );
      }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => updateUserRole(user.userId,context),
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:
                      const Image(image: AssetImage('lib/images/VIT_LOGO.png')),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 7, 0),
                      child: Text(
                        user.name,
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 7, 0),
                      child: Text(
                        user.role == 1 ? "Organiser Approved" : "Participant",
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: user.role == 1 ? Colors.green : Colors.red,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
