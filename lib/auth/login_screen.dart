import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:orrey_web_app/view/orrery_view/orrery_view.dart';
import 'package:orrey_web_app/view/home/home_view.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Color darkBlue = const Color(0xFF001F54);

  @override
  void initState() {
    super.initState();
    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    try {
      final googleUser = await _googleSignIn.signInSilently();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      }
    } catch (e) {
      // Ignore silent sign-in failures
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  Future<void> signInWithEmail() async {
  final email = emailController.text.trim();
  final password = passwordController.text;

  if (!isValidEmail(email)) {
    showError("Please enter a valid email address.");
    return;
  }

  if (password.isEmpty) {
    showError("Password cannot be empty.");
    return;
  }

  setState(() => isLoading = true);
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null && !userCredential.user!.emailVerified) {
      await FirebaseAuth.instance.signOut();
      showError("Email not verified. Please check your inbox.");
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
    }
  } on FirebaseAuthException catch (e) {
    showError(e.message ?? e.toString());
  } catch (e) {
    showError(e.toString());
  }
  setState(() => isLoading = false);
}


  Future<void> signUpWithEmail() async {
  final email = emailController.text.trim();
  final password = passwordController.text;

  if (!isValidEmail(email)) {
    showError("Please enter a valid email address.");
    return;
  }

  if (password.isEmpty) {
    showError("Password cannot be empty.");
    return;
  }

  setState(() => isLoading = true);
  try {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Send email verification
    await userCredential.user?.sendEmailVerification();

    // Sign out the user until they verify their email
    await FirebaseAuth.instance.signOut();

    showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text("Email Verification Sent"),
    content: const Text("A verification email has been sent to your inbox. Please verify your email before logging in."),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("OK"),
      ),
    ],
  ),
);


    // Optionally clear fields
    emailController.clear();
    passwordController.clear();
  } on FirebaseAuthException catch (e) {
    showError(e.message ?? e.toString());
  } catch (e) {
    showError(e.toString());
  }
  setState(() => isLoading = false);
}


  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
    } on FirebaseAuthException catch (e) {
      showError(e.message ?? e.toString());
    } catch (e) {
      if (e.toString().contains('ClientID not set')) {
        showError("Google Sign-In Client ID not set. Please configure it in web/index.html.");
      } else {
        showError(e.toString());
      }
    }
    setState(() => isLoading = false);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
        ),
        Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome to Orrery",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF001F54),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: "Password"),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      if (isLoading)
                        const CircularProgressIndicator()
                      else
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: signInWithEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF001F54),
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("Login", style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: signUpWithEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF001F54),
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: signInWithGoogle,
                              icon: const Icon(Icons.login, color: Color(0xFF001F54)),
                              label: const Text("Sign in with Google", style: TextStyle(color: Color(0xFF001F54))),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF001F54)),
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}