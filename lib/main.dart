import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:orrey_web_app/view/home/home_view.dart';
import 'package:orrey_web_app/view/info/info.dart';
import 'package:orrey_web_app/view/orrery_view/orrery_view.dart';
import 'package:orrey_web_app/view/team/team.dart';
import 'auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Provide Firebase options manually for web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB5Z2DkFLM-UYkoYz34DVCWafM-b2gTWJU",
        authDomain: "virtual-orrery.firebaseapp.com",
        databaseURL: "https://virtual-orrery-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "virtual-orrery",
        storageBucket: "virtual-orrery.appspot.com",
        messagingSenderId: "1049059440872",
        appId: "1:1049059440872:web:74b0462096cfc5dc26315d",
        measurementId: "G-NY2R3QCFBD",
      ),
    );
  } else {
    await Firebase.initializeApp(); // Mobile or desktop
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orrery Web App',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open_Sans',
            ),
        brightness: Brightness.light,
      ),
      home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (snapshot.hasData) {
      return const OrreryView();
    } else {
      return const LoginScreen();
    }
  },
),
routes: {
  '/orrery': (context) => const OrreryView(),
  '/info': (context) => const InfoPage(),
  '/team': (context) => const TeamPage(),
},

    );
  }
}
