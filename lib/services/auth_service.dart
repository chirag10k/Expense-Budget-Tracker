import 'package:budgetingapp/models/expense_model.dart';
import 'package:budgetingapp/models/income_model.dart';
import 'package:budgetingapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences prefs;
  bool isNew;

  //map firebase user object to user
  User _userFromFirebase(FirebaseUser user){
    if(user == null)
      return null;
    else{
      return User(
        uid: user.uid,
        nickname: user.displayName,
        email: user.email,
        photoUrl: user.photoUrl,
        budgetCycle: 1,
        tIncomeAmount: 0,
        tExpenseAmount: 0,
        balance: 0,
      );
    }
  }

  //get user stream on auth state changed
  Stream<User> get onAuthStateChanged {
    return _auth.onAuthStateChanged
        .map(_userFromFirebase);
  }

  //check if the user is already signed up and write data
  _isAlreadySignedUp(User user, bool isNew) async{
    final DatabaseService _db = DatabaseService(user: user);
    final QuerySnapshot snapshot =
        await _db.userCollection.where(
          'uid', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if(isNew){
    //Update data to server if new user
      _db.setUserData();
      //Now write data to local from local
      await prefs.setString('uid', user.uid);
      await prefs.setString('nickname', user.nickname);
      await prefs.setString('email', user.email);
      await prefs.setString('photoUrl', user.photoUrl);
      await prefs.setInt('budgetCycle', user.budgetCycle);
    }
    else{
      //Write data to local from firestore
      user.budgetCycle = documents[0]['budgetCycle'];
      await prefs.setString('uid', documents[0]['uid']);
      await prefs.setString('nickname', documents[0]['nickname']);
      await prefs.setString('email', documents[0]['email']);
      await prefs.setString('photoUrl', documents[0]['photUrl']);
      await prefs.setInt('budgetCycle', documents[0]['budgetCycle']);

    }
  }

  //sign in with google
  Future signInWithGoogle() async {

    prefs = await SharedPreferences.getInstance();

    try {
      final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

      final AuthCredential _credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final AuthResult result = await _auth.signInWithCredential(_credential);
      isNew = result.additionalUserInfo.isNewUser;
      final FirebaseUser firebaseUser = result.user;
      User user = _userFromFirebase(firebaseUser);

      if(user != null){
        //check if user is already signed up
        _isAlreadySignedUp(user, isNew);
      } else
        return user;
    } catch(e) {
      print(e);
      return null;
    }

  }

  //sign out
  Future signOut() async{
    try{
      expList.removeRange(0, expList.length);
      incomeList.removeRange(0, incomeList.length);
      await _auth.signOut();
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      print('Signed Out');
      return null;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}