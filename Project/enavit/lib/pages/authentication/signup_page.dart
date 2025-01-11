import 'package:enavit/pages/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:enavit/services/authentication_service.dart';
import 'package:enavit/theme/theme.dart';
import 'package:enavit/Custom_widgets/custom_scaffold_authentication.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  final AuthenticationService _firebaseAuth = AuthenticationService();
  bool isSnackBarShowing = false;

  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _confirmPasswordTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _firstNameTEC = TextEditingController();
  final TextEditingController _lastNameTEC = TextEditingController();
  final TextEditingController _mobileTEC = TextEditingController();
  final TextEditingController _regNoTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      // full name
                      TextFormField(
                        controller: _firstNameTEC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter First name'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please enter First name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('First Name'),
                          hintText: 'Enter First Name',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _lastNameTEC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter Last name'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please enter Last name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Last Name'),
                          hintText: 'Enter Last Name',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      TextFormField(
                        controller: _emailTEC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter Email'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
                      TextFormField(
                        controller: _passwordTEC,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter Password'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _confirmPasswordTEC,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please Confirm Password'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please Confirm Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Confirm Password'),
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _mobileTEC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please enter Mobile Number'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please enter Mobile Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Mobile Number'),
                          hintText: 'Enter Mobile Number',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _regNoTEC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter Registration Number'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please enter Registration Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Registration Number'),
                          hintText: 'Enter Registration Number',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),

                      // i agree to the processing
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: lightColorScheme.primary,
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: lightColorScheme.primary,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formSignupKey.currentState!.validate() &&
                                      agreePersonalData) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Processing Data'),
                                      ),
                                    );

                                    if (_passwordTEC.text !=
                                        _confirmPasswordTEC.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Passwords do not match'),
                                      ));
                                      return;
                                    }
                                    signup();
                                  } else if (!agreePersonalData) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please agree to the processing of personal data')),
                                    );
                                  }
                                },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text('Sign Up'),
                        ),
                      ),

                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up social media logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dummyUsers() async {
    final List<Map<String, String>> dummyData = [
      {
        "firstName": "Aarav",
        "lastName": "Patel",
        "regNo": "21BCE1829",
        "phoneno": "9876543210"
      },
      {
        "firstName": "Vivaan",
        "lastName": "Sharma",
        "regNo": "22BRS1830",
        "phoneno": "9876543211"
      },
      {
        "firstName": "Aditya",
        "lastName": "Agarwal",
        "regNo": "23BAI1831",
        "phoneno": "9876543212"
      },
      {
        "firstName": "Vihaan",
        "lastName": "Singh",
        "regNo": "24BCE1832",
        "phoneno": "9876543213"
      },
      {
        "firstName": "Krishna",
        "lastName": "Reddy",
        "regNo": "20BRS1833",
        "phoneno": "9876543214"
      },
      {
        "firstName": "Arjun",
        "lastName": "Kumar",
        "regNo": "21BAI1834",
        "phoneno": "9876543215"
      },
      {
        "firstName": "Ishaan",
        "lastName": "Mehta",
        "regNo": "22BCE1835",
        "phoneno": "9876543216"
      },
      {
        "firstName": "Rohan",
        "lastName": "Gupta",
        "regNo": "23BRS1836",
        "phoneno": "9876543217"
      },
      {
        "firstName": "Kabir",
        "lastName": "Joshi",
        "regNo": "24BAI1837",
        "phoneno": "9876543218"
      },
      {
        "firstName": "Dev",
        "lastName": "Nair",
        "regNo": "20BCE1838",
        "phoneno": "9876543219"
      },
      {
        "firstName": "Aryan",
        "lastName": "Shah",
        "regNo": "21BRS1839",
        "phoneno": "9876543220"
      },
      {
        "firstName": "Ayaan",
        "lastName": "Rao",
        "regNo": "22BAI1840",
        "phoneno": "9876543221"
      },
      {
        "firstName": "Ansh",
        "lastName": "Pillai",
        "regNo": "23BCE1841",
        "phoneno": "9876543222"
      },
      {
        "firstName": "Siddharth",
        "lastName": "Sinha",
        "regNo": "24BRS1842",
        "phoneno": "9876543223"
      },
      {
        "firstName": "Rudra",
        "lastName": "Chopra",
        "regNo": "20BAI1843",
        "phoneno": "9876543224"
      },
      {
        "firstName": "Yash",
        "lastName": "Verma",
        "regNo": "21BCE1844",
        "phoneno": "9876543225"
      },
      {
        "firstName": "Parth",
        "lastName": "Malhotra",
        "regNo": "22BRS1845",
        "phoneno": "9876543226"
      },
      {
        "firstName": "Aarush",
        "lastName": "Mishra",
        "regNo": "23BAI1846",
        "phoneno": "9876543227"
      },
      {
        "firstName": "Laksh",
        "lastName": "Roy",
        "regNo": "24BCE1847",
        "phoneno": "9876543228"
      },
      {
        "firstName": "Arnav",
        "lastName": "Bhatt",
        "regNo": "20BRS1848",
        "phoneno": "9876543229"
      },
    ];

    for (var data in dummyData) {
      final String email =
          "${data['firstName']?.toLowerCase()}.${data['lastName']?.toLowerCase()}@vitstudent.ac.in";
      const String password = "Santhosh1@"; // Default password for dummy users
      final String regno = data['regNo']!;
      final String phoneno = data['phoneno']!;
      final String name = "${data['firstName']} ${data['lastName']}";

      final String result = await _firebaseAuth.signUp(
        email: email,
        password: password,
        regno: regno,
        phoneno: phoneno,
        name: name,
      );

      if (result == "success") {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "User ${data['firstName']} ${data['lastName']} uploaded successfully"),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      }
    }
  }

  void signup() async {
    final String email = _emailTEC.text;
    final String password = _passwordTEC.text;
    final String regno = _regNoTEC.text;
    final String phoneno = _mobileTEC.text;
    final String name = "${_firstNameTEC.text} ${_lastNameTEC.text}";
    setState(() {
      _isLoading = true;
    });

    final String result = await _firebaseAuth.signUp(
      email: email,
      password: password,
      regno: regno,
      phoneno: phoneno,
      name: name,
    );

    if (result == "success") {
      if (context.mounted) Navigator.pushNamed(context, '/login');
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final AuthenticationService _firebaseAuth = AuthenticationService();

//   final TextEditingController _passwordTEC = TextEditingController();
//   final TextEditingController _confirmPasswordTEC = TextEditingController();
//   final TextEditingController _emailTEC = TextEditingController();
//   final TextEditingController _firstNameTEC = TextEditingController();
//   final TextEditingController _lastNameTEC = TextEditingController();
//   final TextEditingController _mobileTEC = TextEditingController();
//   final TextEditingController _regNoTEC = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Sign Up",
//                   style: TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 80,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     TextField(
//                       controller: _firstNameTEC,
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.person),
//                           labelText: 'First name',
//                           hintText: 'Enter first name',
//                           isDense: true),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     TextField(
//                       controller: _lastNameTEC,
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.person),
//                           labelText: 'Last name',
//                           hintText: 'Enter last name',
//                           isDense: true),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     TextField(
//                       keyboardType: TextInputType.emailAddress,
//                       controller: _emailTEC,
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.mail),
//                           labelText: 'Email address',
//                           hintText: 'Enter email address',
//                           isDense: true),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     TextField(
//                       obscureText: true,
//                       controller: _passwordTEC,
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.key),
//                           labelText: 'Password',
//                           hintText: 'Enter password',
//                           isDense: true),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     TextField(
//                       obscureText: true,
//                       controller: _confirmPasswordTEC,
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.key),
//                           labelText: 'Confirm password',
//                           hintText: 'Re-enter password',
//                           isDense: true),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     TextField(
//                       controller: _mobileTEC,
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.phone),
//                           labelText: 'Mobile number',
//                           hintText: 'Enter mobile number',
//                           isDense: true),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     TextField(
//                       controller: _regNoTEC,
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.app_registration),
//                           labelText: 'Registration number',
//                           hintText: 'Enter registration number',
//                           isDense: true),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (_firstNameTEC.text.isEmpty ||
//                             _lastNameTEC.text.isEmpty ||
//                             _emailTEC.text.isEmpty ||
//                             _confirmPasswordTEC.text.isEmpty ||
//                             _mobileTEC.text.isEmpty ||
//                             _passwordTEC.text.isEmpty ||
//                             _regNoTEC.text.isEmpty) {
//                           _showToast(context, "Complete form");
//                           return;
//                         }
//                         if (_passwordTEC.text != _confirmPasswordTEC.text) {
//                           _showToast(context, "Passwords do not match");
//                           return;
//                         }
//                         // try {
//                         //   final credential = await FirebaseAuth.instance
//                         //       .createUserWithEmailAndPassword(
//                         //     email: _emailTEC.text,
//                         //     password: _passwordTEC.text,
//                         //   );
//                         //   debugPrint("succesful");
//                         // } on FirebaseAuthException catch (e) {
//                         //   debugPrint("UNsuccesful");
//                         //   if (e.code == "invalid-email") {
//                         //     _showToast(context, "Invalid email address");
//                         //   }
//                         //   if (e.code == 'weak-password') {
//                         //     debugPrint('The password provided is too weak.');
//                         //     _showToast(
//                         //         context, "The password provided is too weak");
//                         //   } else if (e.code == 'email-already-in-use') {
//                         //     debugPrint('The account already exists for that email.');
//                         //     _showToast(context,
//                         //         "The account already exists for that email");
//                         //   }
//                         // } catch (e) {
//                         //   debugPrint("UNsuccesful");
//                         //   debugPrint(e);
//                         // }
//                         signup();
//                       },
//                       child: const Text("Sign up"),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
