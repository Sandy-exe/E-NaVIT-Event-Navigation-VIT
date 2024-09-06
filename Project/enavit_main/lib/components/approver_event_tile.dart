import 'package:enavit_main/components/flutter_flow_theme.dart';
import 'package:enavit_main/models/og_models.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/dashboard/dashboard_screen.dart';

class AEventTile extends StatelessWidget {
  final Event approverEvent;
  const AEventTile({super.key, required this.approverEvent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(event: approverEvent),
          ),
        );
      },
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
                        approverEvent.eventName,
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
