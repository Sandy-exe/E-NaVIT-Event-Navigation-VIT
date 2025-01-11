import 'package:flutter/material.dart';
import 'package:enavit/pages/authentication/signup_page.dart';
import 'package:enavit/pages/authentication/login_page.dart';
import 'package:enavit/Custom_widgets/buttons.dart';

class TopScreenImage extends StatelessWidget {
  const TopScreenImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225, // Adjust the width as needed
      height: 225, // Adjust the height as needed
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('lib/images/VIT_LOGO.png'),
          ),
        ),
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class LoginSignupPage extends StatelessWidget {
  const LoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 15.0, left: 15, bottom: 15, top: 100),
                  child: Column(
                    children: [
                      const ScreenTitle(title: 'Hello'),
                      const Text(
                        'Welcome to Enavit, where you can Navigate your way to Events',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Hero(
                        tag: 'login_btn',
                        child: CustomButton(
                          buttonText: 'Login',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'signup_btn',
                        child: CustomButton(
                          buttonText: 'Sign Up',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'Sign up using',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              debugPrint("Facebook");
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              child: Image.asset('lib/images/facebook.png'),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              debugPrint("Google");
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('lib/images/google.png'),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              debugPrint("LinkedIn");
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              child: Image.asset('lib/images/linkedin.png'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class LoginSignupPage extends StatelessWidget {
//   const LoginSignupPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//               ),
//               onPressed: () async {
//                 debugPrint("Login");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const LoginPage(),
//                   ),
//                 );
//               },
//               child: const Text("Login",
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//               ),
//               onPressed: () {
//                 debugPrint("Sign up");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SignUpPage(),
//                   ),
//                 );
//               },
//               child: const Text("Sign up",
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
