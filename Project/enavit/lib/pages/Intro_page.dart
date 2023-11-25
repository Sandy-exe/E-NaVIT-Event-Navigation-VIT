// import 'index_page.dart';
import 'package:flutter/material.dart';

// temp packages

import 'package:enavit/pages/my_events_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:25.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children:[
                //logo
                Center(
                  child: Image.asset(
                    'lib/images/Denji_pochita.png',
                    height: 300,
                    ),
                ),
                
                // const SizedBox(height: 48,),
        
                //title
                // Text(
                //   'Woof!! Woof!!',
                //   style: GoogleFonts.telex(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   )
                // ),
        
                // const SizedBox(height: 40,),
                
                //sub title
                // Text(
                //   'Ore no goru!..Sore wa...Muneda!!',
                //   style: GoogleFonts.telex(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                
                //start button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const MyEvents(),
                        ),
                      );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(25.0),
                    child: const Center(
                      child: Text(
                        'Lets a go!!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ),
        ),
      )
    );
  }
}