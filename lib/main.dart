import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common/color_extension.dart';
import 'package:fitness/firebase_options.dart';
import 'package:fitness/screens/activity/activity_screen.dart';
import 'package:fitness/screens/goal/goal_screen.dart';
import 'package:fitness/screens/home/gym_screen.dart';
import 'package:fitness/screens/home/home_screen.dart';
import 'package:fitness/screens/home/recipe_scree.dart';
import 'package:fitness/screens/login/login_view.dart';
import 'package:fitness/screens/login/signup_view.dart';
import 'package:fitness/screens/main_tab/main_screen.dart';
import 'package:fitness/screens/on_boarding/started_view.dart';
import 'package:fitness/screens/profile/profile_screen.dart';
import 'package:fitness/services/authentication.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: Consumer<User?>(
        builder: (context, user, _) {
          return MultiProvider(
            providers: [
              if (user != null)
                Provider<DatabaseService>(create: (_) => DatabaseService(userId: user.uid)),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Fitness',
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: "Poppins",
                primaryColor: TextColor.primaryColor1,
              ),
              home: AuthChecker(),
              routes: {
                '/home': (context) => HomeScreen(),
                '/profile': (context) => ProfileScreen(),
                '/activities': (context) => ActivitiesScreen(),
                '/goals': (context) => GoalsScreen(),
                '/gym': (context) => GymWorkoutScreen(),
                '/recipe': (context) => RecipeScreen(),
                '/login': (context) => LoginView(),
                '/signup': (context) => SignUpView(),
              },
            ),
          );
        },
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(
      builder: (context, user, _) {
        if (user == null) {
          return StartedView();
        } else {
          return MainScreen();
        }
      },
    );
  }
}





