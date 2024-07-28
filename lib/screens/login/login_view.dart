import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:fitness/common_widgets/round_textfield.dart';
import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:fitness/screens/login/signup_view.dart';
import 'package:fitness/screens/main_tab/main_screen.dart';
import 'package:fitness/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isCheck = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle login error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    }
  }

  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      }
    } catch (e) {
      // Handle Google sign-in error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Google sign-in failed")));
    }
  }

  void _resetPassword() async {
    if (_emailController.text.isNotEmpty) {
      await _authService.resetPassword(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset email sent")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter your email")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TextColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TextColor.gray, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: TextColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "assets/images/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _passwordController,
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
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _resetPassword,
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                            color: TextColor.gray,
                            fontSize: 14,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                RoundedButton(
                  title: "Login",
                  onPressed: _login,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SignUpView()), // Ensure you have a sign up view
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TextColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Sign Up",
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
