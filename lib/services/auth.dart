import 'package:firebase_auth/firebase_auth.dart';



abstract class AuthBase{
  /// These methods don't have implementations
  User get currentUser;
  Future<User> signInAnonymously();
  Future<void> signOut();
}



class Auth implements AuthBase{
  final _firebaseAuth = FirebaseAuth.instance;


  /// This code is used to get the current user after The User has Logged in
  @override
  User get currentUser => _firebaseAuth.currentUser;

  ///Sign In Anonymously Method
  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return  userCredential.user;
  }
  ///Sign Out Method
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}