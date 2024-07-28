import 'package:fitness/common/color_extension.dart';
import 'package:fitness/common_widgets/round_textfield.dart';
import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/screens/login/complete_profile_view.dart';
import 'package:fitness/screens/login/login_view.dart';
import 'package:fitness/services/authentication.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isCheck = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      AuthService authService =
          Provider.of<AuthService>(context, listen: false);
      UserModel? userModel = await authService.signUpWithEmail(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (userModel != null) {
        // Save user details to the database
        DatabaseService dbService = DatabaseService(userId: userModel.uid);
        await dbService.createUser(UserModel(
          uid: userModel.uid,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteProfileView(userModel: userModel),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      AuthService authService =
          Provider.of<AuthService>(context, listen: false);
      UserModel? userModel = await authService.signInWithGoogle();
      if (userModel != null) {
        // Save user details to the database
        DatabaseService dbService = DatabaseService(userId: userModel.uid);
        await dbService.createUser(UserModel(
          uid: userModel.uid,
          firstName: userModel.firstName,
          lastName: userModel.lastName,
          email: userModel.email,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteProfileView(userModel: userModel),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign in failed. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _trySignUp() {
    if (isCheck) {
      _signUp();
    }
  }

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
                RoundTextField(
                  controller: _firstNameController,
                  hitText: "First Name",
                  icon: "assets/images/user_text.png",
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _lastNameController,
                  hitText: "Last Name",
                  icon: "assets/images/user_text.png",
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "assets/images/email.png",
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _passwordController,
                  hitText: "Password",
                  obscureText: true,
                  icon: "assets/images/lock.png",
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
                // SizedBox(
                //   height: media.width * 0.04,
                // ),
                Row(
                  children: [
                    Checkbox(
                      value: isCheck,
                      onChanged: (value) {
                        setState(() {
                          isCheck = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    Text(
                      "I accept the Terms & Conditions",
                      style: TextStyle(color: TextColor.gray),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                RoundedButton(
                  title: "Sign Up",
                  isLoading: _isLoading,
                  onPressed: _trySignUp,
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
                SizedBox(
                  height: media.width * 0.04,
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
                SizedBox(
                  height: media.width * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: TextColor.gray)),
                      TextSpan(
                          text: "Log In",
                          style: TextStyle(
                              color: TextColor.gray,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
