import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo/modeller/kullanici.dart';
import 'package:google_sign_in/google_sign_in.dart';

class YetkilendirmeServisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; //authentication objesi
   String aktifKullaniciId;

  User get currentUser => _firebaseAuth.currentUser;

  Kullanici _kullaniciOlustur(User kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }
  Future<Kullanici> mailRegister(String email, String password) async {
   var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
   return _kullaniciOlustur(userCredential.user);
  }

  Future<Kullanici> mailLogin(String email, String password) async {
   var userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
   return _kullaniciOlustur(userCredential.user);
  }
  
  Future<void> logout(){
    return _firebaseAuth.signOut();
  }

  Future<Kullanici> googleLogin() async {
   GoogleSignInAccount googleAccount = await GoogleSignIn().signIn();
   GoogleSignInAuthentication googleCard = await googleAccount.authentication;
   AuthCredential loginWithoutPassword = GoogleAuthProvider.credential(idToken: googleCard.idToken, accessToken: googleCard.accessToken);
   UserCredential userCredential = await _firebaseAuth.signInWithCredential(loginWithoutPassword);
   return _kullaniciOlustur(userCredential.user);

  }
}