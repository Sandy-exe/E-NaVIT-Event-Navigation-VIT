import 'package:enavit_main/components/flutter_flow_theme.dart';
import 'package:enavit_main/models/og_models.dart';
import 'package:enavit_main/pages/main_pages/publish_pages/complete_publish_page.dart';
import 'package:flutter/material.dart';

class ApprovedTile extends StatelessWidget {
  final Approval approval;
  const ApprovedTile({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublishEventPage(
              approval: approval,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: approval.approved == 2
              ? Colors.red[300]
              : approval.approved == 1
                  ? Colors.green[300]
                  : Colors.yellow[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.transparent,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('lib/images/Vit_poster.jpg')
                    // approval.eventImageURL == "null"
                    // ? Image.asset('lib/images/Vit_poster.jpg')
                    // : Image.network(
                    //     approval.eventImageURL,
                    //     fit: BoxFit.cover,
                    //   ),
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
                        approval.eventName,
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
