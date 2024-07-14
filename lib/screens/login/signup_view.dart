// import 'package:fitness_app/common/color_extension.dart';
// import 'package:fitness_app/common_widgets/round_textfield.dart';
// import 'package:fitness_app/common_widgets/rounded_button.dart';
// import 'package:fitness_app/models/user_model.dart';
// import 'package:fitness_app/screens/login/complete_profile_view.dart';
// import 'package:fitness_app/screens/login/login_view.dart';
// import 'package:fitness_app/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SignUpView extends StatefulWidget {
//   const SignUpView({super.key});

//   @override
//   State<SignUpView> createState() => _SignUpViewState();
// }

// class _SignUpViewState extends State<SignUpView> {
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool isCheck = false;
//   bool _isLoading = false;

//   void _signUp() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       AuthService authService = Provider.of<AuthService>(context, listen: false);
//       UserModel? userModel = await authService.signUpWithEmail(
//         _firstNameController.text,
//         _lastNameController.text,
//         _emailController.text,
//         _passwordController.text,
//       );
//       if (userModel != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CompleteProfileView(userModel: userModel),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Sign up failed. Please try again.'),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       AuthService authService = Provider.of<AuthService>(context, listen: false);
//       UserModel? userModel = await authService.signInWithGoogle();
//       if (userModel != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CompleteProfileView(userModel: userModel),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Google sign in failed. Please try again.'),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _trySignUp() {
//     if (isCheck) {
//       _signUp();
//     }
//   }

//   // void _trySignUp() async {
//   //   if (isCheck) {
//   //     setState(() {
//   //       _isLoading = true;
//   //     });
//   //     _signUp();
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: TextColor.white,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "Hey there,",
//                   style: TextStyle(color: TextColor.gray, fontSize: 16),
//                 ),
//                 Text(
//                   "Create an Account",
//                   style: TextStyle(
//                       color: TextColor.black,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 SizedBox(
//                   height: media.width * 0.05,
//                 ),
//                 RoundTextField(
//                   controller: _firstNameController,
//                   hitText: "First Name",
//                   icon: "assets/images/user_text.png",
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 RoundTextField(
//                   controller: _lastNameController,
//                   hitText: "Last Name",
//                   icon: "assets/images/user_text.png",
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 RoundTextField(
//                   controller: _emailController,
//                   hitText: "Email",
//                   icon: "assets/images/email.png",
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 RoundTextField(
//                   controller: _passwordController,
//                   hitText: "Password",
//                   icon: "assets/images/lock.png",
//                   obscureText: true,
//                   rigtIcon: TextButton(
//                       onPressed: () {},
//                       child: Container(
//                           alignment: Alignment.center,
//                           width: 20,
//                           height: 20,
//                           child: Image.asset(
//                             "assets/images/show_password.png",
//                             width: 20,
//                             height: 20,
//                             fit: BoxFit.contain,
//                             color: TextColor.gray,
//                           ))),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           isCheck = !isCheck;
//                         });
//                       },
//                       icon: Icon(
//                         isCheck
//                             ? Icons.check_box_outlined
//                             : Icons.check_box_outline_blank_outlined,
//                         color: TextColor.gray,
//                         size: 20,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Text(
//                         "By continuing you accept our Privacy Policy and\nTerm of Use",
//                         style: TextStyle(color: TextColor.gray, fontSize: 10),
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: media.width * 0.4,
//                 ),
//                 _isLoading
//                     ? CircularProgressIndicator()
//                     : RoundedButton(
//                         title: "Register",
//                         onPressed: _trySignUp,
//                       ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: Container(
//                       height: 1,
//                       color: TextColor.gray.withOpacity(0.5),
//                     )),
//                     Text(
//                       "  Or  ",
//                       style: TextStyle(color: TextColor.black, fontSize: 12),
//                     ),
//                     Expanded(
//                         child: Container(
//                       height: 1,
//                       color: TextColor.gray.withOpacity(0.5),
//                     )),
//                   ],
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: _signInWithGoogle,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: TextColor.white,
//                           border: Border.all(
//                             width: 1,
//                             color: TextColor.gray.withOpacity(0.4),
//                           ),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               "assets/images/google.png",
//                               width: 20,
//                               height: 20,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               "Sign in with Google",
//                               style: TextStyle(
//                                 color: TextColor.gray,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LoginView()));
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Already have an account? ",
//                         style: TextStyle(
//                           color: TextColor.black,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         "Login",
//                         style: TextStyle(
//                             color: TextColor.black,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:fitness/common/color_extension.dart';
import 'package:fitness/common_widgets/round_textfield.dart';
import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/screens/login/complete_profile_view.dart';
import 'package:fitness/screens/login/login_view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TextColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TextColor.gray, fontSize: 16),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                      color: TextColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                const RoundTextField(
                  hitText: "First Name",
                  icon: "assets/images/user_text.png",
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                const RoundTextField(
                  hitText: "Last Name",
                  icon: "assets/images/user_text.png",
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                const RoundTextField(
                  hitText: "Email",
                  icon: "assets/images/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Password",
                  icon: "assets/images/lock.png",
                  obscureText: _obscurePassword,
                  rigtIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            _obscurePassword
                                ? "assets/images/show_password.png"
                                : "assets/images/show_password.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: TextColor.gray,
                          ))),
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TextColor.gray,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child:  Text(
                          "By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(color: TextColor.gray, fontSize: 10),
                        ),
                     
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
                RoundedButton(title: "Register", onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CompleteProfileView()  ));
                }),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TextColor.gray.withOpacity(0.5),
                    )),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TextColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TextColor.gray.withOpacity(0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TextColor.white,
          border: Border.all(
            width: 1,
            color: TextColor.gray.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/google.png",
              width: 25,
              height: 25,
            ),
            SizedBox(width: 8),
            Text(
              "Continue with Google",
              style: TextStyle(
                color: TextColor.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),

                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: TextColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                            color: TextColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}