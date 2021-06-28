import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:geo/src/services/auth_service.dart';
import 'package:geo/src/prefs/settings.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignin = GoogleSignIn(scopes: ['email']);
  final prefs = new PreferenciasUsuario();

  //Stream<User> get currentUser => authService.currentUser;

  Future<String> loginGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignin.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    //Firebase Sign in
    final result = await authService.signInWithCredential(credential);

    prefs.login = true;
    prefs.displayName = result.user.displayName;
    prefs.userEmail = result.user.email;
    prefs.photoUrl = result.user.photoURL;

    return '${result.user.displayName}';
  }

  logout() async {
    await authService.logout();
    await googleSignin.signOut();

    prefs.login = false;
    prefs.displayName = '';
    prefs.userEmail = '';
    prefs.photoUrl = '';
    prefs.ultimaPagina = 'login';
    prefs.idUser = '0';

    print("Cerro session");
  }
}
