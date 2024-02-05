import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:thebookstoreapp/DataFromFireStore.dart';
import 'package:thebookstoreapp/main.dart';


class SignningWidget extends StatefulWidget {
  const SignningWidget({Key? key}) : super(key: key);

  @override
  _SignningWidgetState createState() => _SignningWidgetState();
}

class _SignningWidgetState extends State<SignningWidget> {


  final scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return MaterialApp(home:
       Scaffold(body:
       GestureDetector(
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, -1),
                    child: Container(
                      width: 254,
                      height: 97,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Text(
                          'Sign Up',
                          style: FlutterFlowTheme.of(context).headlineLarge,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 1),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: 357,
                        height: 599,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 10, 50),
                                  child: Text(
                                    'Unlock a World of Books with Ease! 📚 Sign up effortlessly using your Google account and dive into a vast library of captivating reads. Embrace the convenience of a seamless entry into the literary realm. Let the journey begin!',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                                  ),
                                ),
                              ),
                              Builder(
                                builder:(context) => Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      signInWithGoogle(context);
                                    },
                                    text: 'Sign Up With Google',
                                    icon: FaIcon(
                                      FontAwesomeIcons.google,
                                    ),
                                    options: FFButtonOptions(
                                      height: 75,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 0, 24, 0),
                                      iconPadding:
                                      EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                      elevation: 3,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    // Check if a user is already signed in
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // If user is already signed in, navigate to MyApp directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      return;
    }

    // Initialize GoogleSignIn
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

    if (googleSignInAccount == null) {
      // The user canceled the sign-in process
      return;
    }

    // Obtain the GoogleSignInAuthentication object
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    // Create a new credential using the GoogleSignInAuthentication object
    final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // Sign in to Firebase with the Google Auth credentials
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);

    // Print user information to the console
    final User user = userCredential.user!;
    print("User signed in: ${user.displayName} (${user.email})");

    // Navigate to MyApp after sign-in
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DataFromFireStore()),
    );
  } catch (e) {
    print("Error during Google sign in: $e");
  }
}
