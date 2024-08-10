import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create User object based on Firebase User
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null
        ? UserModel(uid: user.uid, firstName: '', lastName: '', email: user.email!)
        : null;
  }

  // Auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        DatabaseService dbService = DatabaseService(userId: user.uid); // Initialize with userId
        await dbService.createUser(_userFromFirebaseUser(user)!); // Update Firestore
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<UserModel?> signUpWithEmail(String firstName, String lastName, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        UserModel newUser = UserModel(uid: user.uid, firstName: firstName, lastName: lastName, email: email);
        DatabaseService dbService = DatabaseService(userId: user.uid); // Initialize with userId
        await dbService.createUser(newUser); // Create user document in Firestore
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        String firstName = googleUser.displayName?.split(' ').first ?? '';
        String lastName = googleUser.displayName?.split(' ').last ?? '';
        UserModel newUser = UserModel(uid: user.uid, firstName: firstName, lastName: lastName, email: user.email!);
        DatabaseService dbService = DatabaseService(userId: user.uid); // Initialize with userId
        await dbService.createUser(newUser);
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
